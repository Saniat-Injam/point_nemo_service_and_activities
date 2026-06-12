import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/loading_prograsse_indicator.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/logger.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/user_booking_model.dart';

class UserBookingsController extends GetxController {
  final _networkCaller = NetworkCaller();

  // ── Scroll ─────────────────────────────────────────────────────────────────
  final scrollController = ScrollController();

  // ── Tab ────────────────────────────────────────────────────────────────────
  final selectedTabIndex = 0.obs;

  // ── Data ──────────────────────────────────────────────────────────────────
  final allBookings = <UserBookingModel>[].obs;
  final isLoading = false.obs;

  // ── Pagination ────────────────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _limit = 10;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  // Mapping tab index → API filter value
  static const List<String> _filters = ['upcoming', 'completed', 'cancel'];

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
    ever(selectedTabIndex, (_) => _onTabChanged());
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          hasMore.value) {
        fetchMoreBookings();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void _onTabChanged() {
    _currentPage = 1;
    hasMore.value = true;
    allBookings.clear();
    fetchBookings();
  }

  List<UserBookingModel> get filteredBookings => allBookings.toList();

  // ── Fetch first page ───────────────────────────────────────────────────────
  Future<void> fetchBookings() async {
    isLoading.value = true;
    _currentPage = 1;

    final filter = _filters[selectedTabIndex.value];
    final url =
        '${AppUrls.getUserBookings}?filter=$filter&page=$_currentPage&limit=$_limit';

    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final outerData = response.responseData['data'];
      final List rawList = outerData['data'] ?? [];
      final meta = BookingMetaModel.fromJson(outerData['meta'] ?? {});

      allBookings.assignAll(
        rawList.map((e) => UserBookingModel.fromJson(e)).toList(),
      );
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  // ── Load more (infinite scroll) ────────────────────────────────────────────
  Future<void> fetchMoreBookings() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final filter = _filters[selectedTabIndex.value];
    final url =
        '${AppUrls.getUserBookings}?filter=$filter&page=$nextPage&limit=$_limit';

    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final outerData = response.responseData['data'];
      final List rawList = outerData['data'] ?? [];
      final meta = BookingMetaModel.fromJson(outerData['meta'] ?? {});

      allBookings.addAll(
        rawList.map((e) => UserBookingModel.fromJson(e)).toList(),
      );
      _currentPage = meta.page;
      hasMore.value = meta.page < meta.totalPages;
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  // ── Cancel booking (local optimistic removal) ──────────────────────────────
  // void cancelBooking(String bookingId) {
  //   allBookings.removeWhere((b) => b.id == bookingId);
  // }

  Future<void> cancelBooking({required String id}) async {
    try {
      loadingProgressIndicator();
      final response = await NetworkCaller().deleteRequest(
        AppUrls.cancelBooking(id),
        'Bearer ${StorageService.token ?? ''}',
      );
      await hideProgressIndicator();
      if (response.isSuccess) {
        fetchBookings();
      } else {
        AppLoggerHelper.error("Error : ${response.responseData['message']}");
      }
    } catch (e) {
      await hideProgressIndicator();
      AppLoggerHelper.error("Error : $e");
    }
  }
}
