import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/models/user_favorite_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_activities_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_controller.dart';

class UserFavoriteController extends GetxController {
  final _networkCaller = NetworkCaller();

  final RxList<UserFavoriteModel> favoriteItems = <UserFavoriteModel>[].obs;
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
    fetchFavorites();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchMoreFavorites();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchFavorites() async {
    _currentPage = 1;
    hasMore.value = true;
    favoriteItems.clear();
    isLoading.value = true;

    final url = AppUrls.getUserFavorites(_currentPage, _pageLimit);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta =
          ServiceMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      favoriteItems.assignAll(
        rawList
            .map((e) => UserFavoriteModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> fetchMoreFavorites() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url = AppUrls.getUserFavorites(nextPage, _pageLimit);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta =
          ServiceMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      favoriteItems.addAll(
        rawList
            .map((e) => UserFavoriteModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  Future<void> removeFavorite(String serviceId) async {
    final index =
        favoriteItems.indexWhere((item) => item.service?.id == serviceId);
    if (index != -1) {
      final removedItem = favoriteItems[index];
      favoriteItems.removeAt(index);

      // Optimistic update for other controllers
      _updateOtherControllers(serviceId, false);

      final String url = AppUrls.toggleFavorite(serviceId);
      final response = await _networkCaller.deleteRequest(url, null);

      if (!response.isSuccess) {
        favoriteItems.insert(index, removedItem);
        // Revert other controllers
        _updateOtherControllers(serviceId, true);
        AppHelperFunctions.showSnackBar(response.errorMessage);
      }
    }
  }

  void _updateOtherControllers(String serviceId, bool isFavorite) {
    if (Get.isRegistered<FeaturedCoursesController>()) {
      Get.find<FeaturedCoursesController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
    if (Get.isRegistered<FeaturedActivitiesController>()) {
      Get.find<FeaturedActivitiesController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
    if (Get.isRegistered<ServiceController>()) {
      Get.find<ServiceController>()
          .updateFavoriteStatus(serviceId, isFavorite);
    }
  }
}
