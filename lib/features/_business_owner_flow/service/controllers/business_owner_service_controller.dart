import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';

class BusinessOwnerServiceController extends GetxController {
  final _networkCaller = NetworkCaller();

  // ── Category / Type ──────────────────────────────────────────────────────
  /// Display labels
  final sportsList = [
    'Water Sports',
    'Boat Rental',
    'Diving Course',
    'Fishing Trip',
  ].obs;

  /// Map display label → API type value
  final Map<String, String> _typeMap = {
    'Water Sports': 'WATER_SPORTS',
    'Boat Rental': 'BOAT_RENTAL',
    'Diving Course': 'DIVING_COURSE',
    'Fishing Trip': 'FISHING_TRIP',
  };

  final selectedSports = 'Water Sports'.obs;

  String get _selectedApiType => _typeMap[selectedSports.value] ?? 'WATER_SPORTS';

  // ── Data ─────────────────────────────────────────────────────────────────
  final services = <ServiceModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // ── Pagination ────────────────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _limit = 10;
  final hasMore = true.obs;

  // Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchServices();

    // Listen for category changes → reload
    ever(selectedSports, (_) => _onCategoryChanged());

    // Infinite scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          hasMore.value) {
        fetchMoreServices();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onCategoryChanged() {
    _currentPage = 1;
    hasMore.value = true;
    services.clear();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    _currentPage = 1;
    hasMore.value = true;

    final ownerId = StorageService.id ?? '';
    final url =
        '${AppUrls.getAllServices}?page=$_currentPage&limit=$_limit&type=$_selectedApiType&ownerId=$ownerId';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = ServiceMetaModel.fromJson(data['meta']);

      services.assignAll(rawList.map((e) => ServiceModel.fromJson(e)).toList());
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> fetchMoreServices() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final ownerId = StorageService.id ?? '';
    final url =
        '${AppUrls.getAllServices}?page=$nextPage&limit=$_limit&type=$_selectedApiType&ownerId=$ownerId';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = ServiceMetaModel.fromJson(data['meta']);

      services.addAll(rawList.map((e) => ServiceModel.fromJson(e)).toList());
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  /// Helper: image fallback per type
  String getFallbackImage(String type) {
    switch (type) {
      case 'BOAT_RENTAL':
        return 'assets/images/rent_boats.png';
      case 'WATER_SPORTS':
        return 'assets/images/water_sports.png';
      case 'DIVING_COURSE':
        return 'assets/images/diving_courses.png';
      case 'FISHING_TRIP':
        return 'assets/images/fishing_trips.png';
      default:
        return 'assets/images/water_sports.png';
    }
  }
}
