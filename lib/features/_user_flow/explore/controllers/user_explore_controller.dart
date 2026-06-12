import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/controllers/search_and_filter_controller.dart';

class UserExploreController extends GetxController {
  final _networkCaller = NetworkCaller();

  // ── Categories ───────────────────────────────────────────────────────────
  final categories = ['All', 'Boat Rental', 'Water Sports', 'Diving Course', 'Fishing Trip'];

  final Map<String, String?> _typeMap = {
    'All': null,
    'Boat Rental': 'BOAT_RENTAL',
    'Water Sports': 'WATER_SPORTS',
    'Diving Course': 'DIVING_COURSE',
    'Fishing Trip': 'FISHING_TRIP',
  };

  final Map<String, String> _categoryEmoji = {
    'All': '',
    'Boat Rental': '🛥️',
    'Water Sports': '🏄',
    'Diving Course': '🤿',
    'Fishing Trip': '🎣',
  };

  final selectedCategory = 'All'.obs;

  String? get _selectedApiType => _typeMap[selectedCategory.value];
  String emojiFor(String category) => _categoryEmoji[category] ?? '';

  // ── Search & Filter ──────────────────────────────────────────────────────
  late final searchAndFilterController = SearchAndFilterController(
    onSearch: (_) => _onCategoryChanged(),
  );

  // ── Data ─────────────────────────────────────────────────────────────────
  final services = <ServiceModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // ── Pagination ───────────────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _limit = 10;
  final hasMore = true.obs;

  // Scroll controller for infinite scroll
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchServices();

    ever(selectedCategory, (_) => _onCategoryChanged());

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
    searchAndFilterController.dispose();
    super.onClose();
  }



  void changeCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
  }

  void _onCategoryChanged() {
    _currentPage = 1;
    hasMore.value = true;
    services.clear();
    fetchServices();
  }

  // ── Fetch first page ─────────────────────────────────────────────────────
  Future<void> fetchServices() async {
    isLoading.value = true;
    _currentPage = 1;
    hasMore.value = true;

    final url = _buildUrl(_currentPage);
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

  // ── URL builder (type + search) ───────────────────────────────────────────
  String _buildUrl(int page) {
    final params = StringBuffer('${AppUrls.getAllServices}?page=$page&limit=$_limit');
    final apiType = _selectedApiType;
    if (apiType != null) params.write('&type=$apiType');
    final q = searchAndFilterController.searchQuery.value;
    if (q.isNotEmpty) params.write('&search=${Uri.encodeComponent(q)}');
    return params.toString();
  }

  // ── Fetch more (infinite scroll) ──────────────────────────────────────────
  Future<void> fetchMoreServices() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url = _buildUrl(nextPage);
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

  /// Image fallback per service type
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
