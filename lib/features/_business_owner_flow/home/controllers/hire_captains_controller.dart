import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/favorite/controllers/business_owner_favorite_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/captain_model.dart';

class HireCaptainsController extends GetxController {
  final _networkCaller = NetworkCaller();

  // ── Gender filter ─────────────────────────────────────────────────────────
  /// 'MALE' | 'FEMALE' | 'OTHER'
  final selectedGender = 'MALE'.obs;

  // ── Data ──────────────────────────────────────────────────────────────────
  final captains = <CaptainModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  /// IDs of captains that the user has already added to favourites this session.
  /// Used for optimistic UI on the heart icon.
  final favoritedIds = <String>{}.obs;

  // ── Pagination ────────────────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _limit = 10;
  final hasMore = true.obs;

  // Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCaptains();

    // Reload when gender changes
    ever(selectedGender, (_) => _onGenderChanged());

    // Infinite scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          hasMore.value) {
        fetchMoreCaptains();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void changeGender(String gender) {
    selectedGender.value = gender;
  }

  void _onGenderChanged() {
    _currentPage = 1;
    hasMore.value = true;
    captains.clear();
    fetchCaptains();
  }

  Future<void> fetchCaptains() async {
    isLoading.value = true;
    _currentPage = 1;
    hasMore.value = true;

    final url =
        '${AppUrls.getAvailableCaptains}?gender=${selectedGender.value}&page=$_currentPage&limit=$_limit';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = CaptainMetaModel.fromJson(data['meta']);

      captains.assignAll(rawList.map((e) => CaptainModel.fromJson(e)).toList());
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> fetchMoreCaptains() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url =
        '${AppUrls.getAvailableCaptains}?gender=${selectedGender.value}&page=$nextPage&limit=$_limit';
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final data = response.responseData['data'];
      final List rawList = data['data'] ?? [];
      final meta = CaptainMetaModel.fromJson(data['meta']);

      captains.addAll(rawList.map((e) => CaptainModel.fromJson(e)).toList());
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  // ── Toggle favourite ──────────────────────────────────────────────────────
  Future<void> toggleFavorite(String captainId) async {
    final isFavorited = favoritedIds.contains(captainId);

    if (isFavorited) {
      // ── Remove ──────────────────────────────────────────────────────
      favoritedIds.remove(captainId); // optimistic revert

      final url = AppUrls.toggleCaptainFavorite(captainId);
      final response = await _networkCaller.deleteRequest(url, null);

      if (response.isSuccess) {
        // Sync favourites screen list
        if (Get.isRegistered<BusinessOwnerFavoriteController>()) {
          Get.find<BusinessOwnerFavoriteController>().fetchFavorites();
        }
      } else {
        favoritedIds.add(captainId); // revert on failure
        AppHelperFunctions.showSnackBar(response.errorMessage);
      }
    } else {
      // ── Add ─────────────────────────────────────────────────────────
      favoritedIds.add(captainId); // optimistic add

      final url = AppUrls.toggleCaptainFavorite(captainId);
      final response = await _networkCaller.postRequest(url, body: {});

      if (response.isSuccess) {
        // Sync favourites screen list
        if (Get.isRegistered<BusinessOwnerFavoriteController>()) {
          Get.find<BusinessOwnerFavoriteController>().fetchFavorites();
        }
      } else {
        favoritedIds.remove(captainId); // revert on failure
        AppHelperFunctions.showSnackBar(response.errorMessage);
      }
    }
  }
}
