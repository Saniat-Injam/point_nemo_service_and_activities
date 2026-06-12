import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/loading_prograsse_indicator.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/logger.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/models/booking_model.dart';

class BookingController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // Filter chips — UI shows 'Accept' but API uses 'active'
  final selectedFilter = 'All'.obs;
  final filters = ['All', 'Pending', 'Accepted', 'Completed', 'Rejected'];

  // Data
  final isLoading = false.obs;
  final bookings = <CaptainBookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHires();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchHires();
  }

  List<CaptainBookingModel> get filteredBookings => bookings;

  Future<void> fetchHires() async {
    isLoading.value = true;

    final filterParam = _getFilterParam(selectedFilter.value);
    final url =
        '${AppUrls.captainHiresFilter}?filter=$filterParam&page=1&limit=10';

    final response = await _networkCaller.getRequest(url);
    if (response.isSuccess) {
      final List data = response.responseData['data']['data'] ?? [];
      bookings.value = data
          .map((e) => CaptainBookingModel.fromJson(e))
          .toList();
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }
    isLoading.value = false;
  }

  /// Maps the UI filter label to the API query param value.
  String _getFilterParam(String filter) {
    switch (filter) {
      case 'Pending':
        return 'pending';
      case 'Accepted':
        return 'active'; // API uses 'active' for what UI calls 'Accept'
      case 'Completed':
        return 'completed';
      case 'Rejected':
        return 'rejected';
      default:
        return 'all';
    }
  }

  // accept booking
  Future<void> acceptOrReBooking({
    required String id,
    required bool isAccept,
  }) async {
    try {
      loadingProgressIndicator();
      final body = {
        "status": isAccept ? "ACTIVE" : "REJECTED", // or "REJECTED"
      };
      final response = await NetworkCaller().patchRequest(
        AppUrls.approveBooking(id),
        body: body,
      );
      await hideProgressIndicator();
      if (response.isSuccess) {
        fetchHires();
      } else {
        AppLoggerHelper.error("Error : ${response.responseData['message']}");
      }
    } catch (e) {
      await hideProgressIndicator();
      AppLoggerHelper.error("Error : $e");
    }
  }
}
