import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/hire_captains_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/captain_model.dart';

class BusinessOwnerFavoriteController extends GetxController {
  final _networkCaller = NetworkCaller();

  final RxList<CaptainModel> favoriteCaptains = <CaptainModel>[].obs;
  final isLoading = true.obs;

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
    favoriteCaptains.clear();
    isLoading.value = true;

    final url = AppUrls.getCaptainFavorites(_currentPage, _pageLimit);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta =
          CaptainMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      favoriteCaptains.assignAll(
        rawList
            .map((e) => CaptainModel.fromJson(e['captain'] as Map<String, dynamic>))
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
    final url = AppUrls.getCaptainFavorites(nextPage, _pageLimit);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta =
          CaptainMetaModel.fromJson(data['meta'] as Map<String, dynamic>);

      favoriteCaptains.addAll(
        rawList
            .map((e) => CaptainModel.fromJson(e['captain'] as Map<String, dynamic>))
            .toList(),
      );

      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  Future<void> removeFavorite(String captainId) async {
    final index =
        favoriteCaptains.indexWhere((captain) => captain.id == captainId);
    if (index != -1) {
      final removedCaptain = favoriteCaptains[index];
      favoriteCaptains.removeAt(index);

      final url = AppUrls.toggleCaptainFavorite(captainId);
      final response = await _networkCaller.deleteRequest(url, null);

      if (response.isSuccess) {
        // Sync heart icon on HireCaptainsScreen back to unfilled state
        if (Get.isRegistered<HireCaptainsController>()) {
          Get.find<HireCaptainsController>().favoritedIds.remove(captainId);
        }
      } else {
        favoriteCaptains.insert(index, removedCaptain);
        AppHelperFunctions.showSnackBar(response.errorMessage);
      }
    }
  }
}
