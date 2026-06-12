import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/boat_rental_model.dart';

class BoatFilterController extends GetxController {
  final _networkCaller = NetworkCaller();

  // ── UI filter state ──────────────────────────────────────────────────────

  /// Display label → API enum value map (only valid backend enums)
  static const Map<String, String> boatTypeApiMap = {
    'Motorboat': 'MOTORBOAT',
    'Catamaran': 'CATAMARAN',
    'RIB': 'RIB',
    'Jet Ski': 'JET_SKI',
    'Gulet': 'GULET',
    'Houseboat': 'HOUSEBOAT',
  };

  static const List<String> boatTypeLabels = [
    'Motorboat',
    'Catamaran',
    'RIB',
    'Jet Ski',
    'Gulet',
    'Houseboat',
  ];

  final boatType = ''.obs; // display label, empty means "All"
  final priceRange = const RangeValues(0, 10000).obs;
  final numPeople = 1.obs;
  final lengthRange = const RangeValues(0, 100).obs;
  final address = ''.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  // ── Scroll ───────────────────────────────────────────────────────────────
  final scrollController = ScrollController();
  final resultsKey = GlobalKey();

  // ── API result state ─────────────────────────────────────────────────────
  final boatRentals = <BoatRentalModel>[].obs;
  final isLoading = false.obs;
  final hasResults = false.obs; // true once first successful response received

  // Pagination
  int _currentPage = 1;
  static const int _limit = 10;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  // ── Filter helpers ───────────────────────────────────────────────────────

  void updateBoatType(String label) {
    boatType.value = boatType.value == label ? '' : label;
  }

  void updatePriceRange(RangeValues values) => priceRange.value = values;

  void updateLengthRange(RangeValues values) => lengthRange.value = values;

  void incrementPeople() => numPeople.value++;
  void decrementPeople() {
    if (numPeople.value > 1) numPeople.value--;
  }

  void updateAddress(String value) => address.value = value;

  void setStartDate(DateTime? date) => startDate.value = date;
  void setEndDate(DateTime? date) => endDate.value = date;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void resetFilters() {
    boatType.value = '';
    priceRange.value = const RangeValues(0, 10000);
    numPeople.value = 1;
    lengthRange.value = const RangeValues(0, 100);
    address.value = '';
    startDate.value = null;
    endDate.value = null;
    boatRentals.clear();
    hasResults.value = false;
  }

  // ── API call ─────────────────────────────────────────────────────────────

  /// Called when user taps "Submit" – fetches page 1 with current filters.
  Future<void> applyFilters() async {
    _currentPage = 1;
    hasMore.value = true;
    boatRentals.clear();
    hasResults.value = false;
    isLoading.value = true;

    final url = _buildUrl(page: 1);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final rawData = response.responseData['data'];
      if (rawData is Map<String, dynamic> || rawData is Map) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData as Map);
        final List rawList = data['data'] is List ? data['data'] : [];
        final metaData = data['meta'] is Map ? Map<String, dynamic>.from(data['meta']) : <String, dynamic>{};
        final meta = BoatRentalMetaModel.fromJson(metaData);
        boatRentals.assignAll(
          rawList.map((e) => BoatRentalModel.fromJson(e)).toList(),
        );
        _currentPage = meta.page;
        hasMore.value = meta.page < meta.totalPages;
        hasResults.value = true;
      } else if (rawData is List) {
        boatRentals.assignAll(
          rawData.map((e) => BoatRentalModel.fromJson(e)).toList(),
        );
        hasMore.value = false;
        hasResults.value = true;
      }
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
    // Scroll to bottom to show results
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Step 1: after 200ms the results widgets are built and layout is done.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!scrollController.hasClients) return;
      // Jump close to the end first – this forces Flutter to lay out all
      // list children so maxScrollExtent is computed correctly.
      final max = scrollController.position.maxScrollExtent;
      scrollController.jumpTo((max - 1).clamp(0.0, max));

      // Step 2: now animate to the true final position.
      Future.delayed(const Duration(milliseconds: 50), () {
        if (!scrollController.hasClients) return;
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      });
    });
  }

  Future<void> fetchMoreBoatRentals() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final nextPage = _currentPage + 1;
    final url = _buildUrl(page: nextPage);
    final response = await _networkCaller.getRequest(url);

    if (response.isSuccess) {
      final rawData = response.responseData['data'];
      if (rawData is Map<String, dynamic> || rawData is Map) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData as Map);
        final List rawList = data['data'] is List ? data['data'] : [];
        final metaData = data['meta'] is Map ? Map<String, dynamic>.from(data['meta']) : <String, dynamic>{};
        final meta = BoatRentalMetaModel.fromJson(metaData);
        boatRentals.addAll(
          rawList.map((e) => BoatRentalModel.fromJson(e)).toList(),
        );
        _currentPage = meta.page;
        hasMore.value = meta.page < meta.totalPages;
      }
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoadingMore.value = false;
  }

  String _buildUrl({required int page}) {
    final buf = StringBuffer(
      '${AppUrls.getBoatRentals}?page=$page&limit=$_limit',
    );

    // address
    final addr = address.value.trim();
    if (addr.isNotEmpty) buf.write('&address=${Uri.encodeComponent(addr)}');

    // date range
    final sd = startDate.value;
    final ed = endDate.value;
    if (sd != null) buf.write('&startDate=${sd.toUtc().toIso8601String()}');
    if (ed != null) buf.write('&endDate=${ed.toUtc().toIso8601String()}');

    // boat type (API enum)
    final bt = boatType.value;
    if (bt.isNotEmpty) {
      final apiValue = boatTypeApiMap[bt];
      if (apiValue != null) buf.write('&boatType=$apiValue');
    }

    // price
    final prMin = priceRange.value.start.toInt();
    final prMax = priceRange.value.end.toInt();
    if (prMin > 0) buf.write('&priceMin=$prMin');
    if (prMax < 10000) buf.write('&priceMax=$prMax');

    // length
    final lenMin = lengthRange.value.start.toInt();
    final lenMax = lengthRange.value.end.toInt();
    if (lenMin > 0) buf.write('&lengthMin=$lenMin');
    if (lenMax < 100) buf.write('&lengthMax=$lenMax');

    // people / capacity
    if (numPeople.value > 1) buf.write('&capacity=${numPeople.value}');

    return buf.toString();
  }
}
