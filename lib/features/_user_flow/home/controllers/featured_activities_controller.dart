import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/core/models/response_data.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_controller.dart';

class FeaturedActivitiesController extends GetxController {
  final _networkCaller = NetworkCaller();

  /// Full paginated list — used by AllFeaturedActivitiesScreen.
  final RxList<ServiceModel> allActivities = <ServiceModel>[].obs;

  bool get hasAnyFavorite => allActivities.any((e) => e.isFavorite);

  /// First 3 items — shown on the home screen.
  final RxList<ServiceModel> featuredActivities = <ServiceModel>[].obs;

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
    fetchActivities();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchMoreActivities();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchActivities() async {
    _currentPage = 1;
    hasMore.value = true;
    allActivities.clear();
    isLoading.value = true;

    final url =
        '${AppUrls.getAllActivities}?page=$_currentPage&limit=$_pageLimit';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta =
          ServiceMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      allActivities.assignAll(
        rawList
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      // Home screen shows only first 3
      featuredActivities.assignAll(
        allActivities.length > 3 ? allActivities.sublist(0, 3) : allActivities,
      );

      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> fetchMoreActivities() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url =
        '${AppUrls.getAllActivities}?page=$nextPage&limit=$_pageLimit';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta =
          ServiceMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      allActivities.addAll(
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

  /// Toggles favourite status for the activity at [index] in [allActivities].
  /// Uses optimistic UI update — reverts on API failure.
  Future<void> toggleFavorite(int index, String serviceId) async {
    final bool current = allActivities[index].isFavorite;
    allActivities[index].isFavorite = !current;
    allActivities.refresh();

    // Sync the featuredActivities snapshot too
    final featuredIdx = featuredActivities.indexWhere((e) => e.id == serviceId);
    if (featuredIdx != -1) {
      featuredActivities[featuredIdx].isFavorite = !current;
      featuredActivities.refresh();
    }

    ResponseData response;
    if (!current) {
      response = await _networkCaller.postRequest(
        AppUrls.toggleFavorite(serviceId),
        body: {},
      );
    } else {
      response = await _networkCaller.deleteRequest(
        AppUrls.toggleFavorite(serviceId),
        null,
      );
    }

    if (!response.isSuccess) {
      allActivities[index].isFavorite = current;
      allActivities.refresh();
      if (featuredIdx != -1) {
        featuredActivities[featuredIdx].isFavorite = current;
        featuredActivities.refresh();
      }
      AppHelperFunctions.showSnackBar(response.errorMessage, isError: true);
    } else {
      // Sync with other controllers on success
      _syncWithOthers(serviceId, !current);
    }
  }

  void _syncWithOthers(String serviceId, bool isFavorite) {
    if (Get.isRegistered<FeaturedCoursesController>()) {
      Get.find<FeaturedCoursesController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
    if (Get.isRegistered<ServiceController>()) {
      Get.find<ServiceController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
  }

  /// Synchronizes favorite status from other screens (e.g. Favorite Screen)
  void updateFavoriteStatus(String serviceId, bool isFavorite) {
    final int index = allActivities.indexWhere((e) => e.id == serviceId);
    if (index != -1) {
      allActivities[index].isFavorite = isFavorite;
      allActivities.refresh();
    }

    final int featuredIdx = featuredActivities.indexWhere((e) => e.id == serviceId);
    if (featuredIdx != -1) {
      featuredActivities[featuredIdx].isFavorite = isFavorite;
      featuredActivities.refresh();
    }
  }
}
