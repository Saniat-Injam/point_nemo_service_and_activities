import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/core/models/response_data.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_activities_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_controller.dart';

class FeaturedCoursesController extends GetxController {
  final _networkCaller = NetworkCaller();

  // Full list fetched from API
  final RxList<ServiceModel> allCourses = <ServiceModel>[].obs;

  bool get hasAnyFavorite => allCourses.any((e) => e.isFavorite);

  // First 3 items — shown on the home screen
  final RxList<ServiceModel> featuredCourses = <ServiceModel>[].obs;

  final isLoading = false.obs;

  // Pagination
  int _currentPage = 1;
  static const int _pageLimit = 10;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchCourses();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      fetchMoreCourses();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchCourses() async {
    _currentPage = 1;
    hasMore.value = true;
    allCourses.clear();
    isLoading.value = true;

    final url =
        '${AppUrls.getDivingCourses}?page=$_currentPage&limit=$_pageLimit';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = ServiceMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      allCourses.assignAll(
        rawList
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      // Home screen shows only first 3
      featuredCourses.assignAll(
        allCourses.length > 3 ? allCourses.sublist(0, 3) : allCourses,
      );

      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> fetchMoreCourses() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url =
        '${AppUrls.getDivingCourses}?page=$nextPage&limit=$_pageLimit';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = ServiceMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      allCourses.addAll(
        rawList
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  /// Toggles favourite status for the course at [index] in [allCourses].
  /// Uses optimistic UI update — reverts on API failure.
  Future<void> toggleFavorite(int index, String serviceId) async {
    // Determine which list the index belongs to and flip the value
    final bool current = allCourses[index].isFavorite;
    allCourses[index].isFavorite = !current;
    allCourses.refresh();

    // Also sync the featuredCourses snapshot
    final featuredIdx = featuredCourses.indexWhere((e) => e.id == serviceId);
    if (featuredIdx != -1) {
      featuredCourses[featuredIdx].isFavorite = !current;
      featuredCourses.refresh();
    }

    ResponseData response;
    if (!current) {
      // Was not a favourite → add it
      response = await _networkCaller.postRequest(
        AppUrls.toggleFavorite(serviceId),
        body: {},
      );
    } else {
      // Was a favourite → remove it
      response = await _networkCaller.deleteRequest(
        AppUrls.toggleFavorite(serviceId),
        null,
      );
    }

    if (!response.isSuccess) {
      // Revert on failure
      allCourses[index].isFavorite = current;
      allCourses.refresh();
      if (featuredIdx != -1) {
        featuredCourses[featuredIdx].isFavorite = current;
        featuredCourses.refresh();
      }
      AppHelperFunctions.showSnackBar(response.errorMessage, isError: true);
    } else {
      // Sync with other controllers on success
      _syncWithOthers(serviceId, !current);
    }
  }

  void _syncWithOthers(String serviceId, bool isFavorite) {
    if (Get.isRegistered<FeaturedActivitiesController>()) {
      Get.find<FeaturedActivitiesController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
    if (Get.isRegistered<ServiceController>()) {
      Get.find<ServiceController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
  }

  /// Synchronizes favorite status from other screens (e.g. Favorite Screen)
  void updateFavoriteStatus(String serviceId, bool isFavorite) {
    final int index = allCourses.indexWhere((e) => e.id == serviceId);
    if (index != -1) {
      allCourses[index].isFavorite = isFavorite;
      allCourses.refresh();
    }

    final int featuredIdx = featuredCourses.indexWhere((e) => e.id == serviceId);
    if (featuredIdx != -1) {
      featuredCourses[featuredIdx].isFavorite = isFavorite;
      featuredCourses.refresh();
    }
  }
}
