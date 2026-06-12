import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/loading_prograsse_indicator.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/logger.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/models/business_owner_booking_model.dart';

class BusinessOwnerBookingController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // Top toggle: 0 = Bookings, 1 = Captains Bookings
  final selectedToggle = 0.obs;

  // Filter chips
  final selectedFilter = 'All'.obs;
  final filters = ['All', 'Pending', 'Accepted', 'Completed', 'Rejected'];

  // Data
  final isLoading = false.obs;
  final bookings = <BusinessOwnerBookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOwnerBookings();
  }

  void changeToggle(int index) {
    selectedToggle.value = index;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchOwnerBookings();
  }

  List<BusinessOwnerBookingModel> get filteredBookings {
    if (selectedFilter.value == 'All') {
      return bookings;
    }
    return bookings.where((b) => b.status == selectedFilter.value).toList();
  }

  Future<void> fetchOwnerBookings() async {
    isLoading.value = true;

    String url = '${AppUrls.ownerBookings}?page=1&limit=10';

    if (selectedFilter.value != 'All') {
      final filterParam = _getFilterParam(selectedFilter.value);
      url += '&filter=$filterParam';
    }

    final response = await _networkCaller.getRequest(url);
    if (response.isSuccess) {
      final List data = response.responseData['data']['data'];
      bookings.value = data
          .map((e) => BusinessOwnerBookingModel.fromJson(e))
          .toList();
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }
    isLoading.value = false;
  }

  String _getFilterParam(String filter) {
    switch (filter) {
      case 'Pending':
        return 'pending';
      case 'Accepted':
        return 'active';
      case 'Completed':
        return 'completed';
      case 'Rejected':
        return 'rejected';
      default:
        return '';
    }
  }

  // accept booking
  Future<void> acceptBooking({required String id}) async {
    try {
      loadingProgressIndicator();
      final response = await NetworkCaller().patchRequest(
        AppUrls.acceptBooking(id),
        body: {},
      );
      await hideProgressIndicator();
      if (response.isSuccess) {
        fetchOwnerBookings();
      } else {
        AppLoggerHelper.error("Error : ${response.responseData['message']}");
      }
    } catch (e) {
      await hideProgressIndicator();
      AppLoggerHelper.error("Error : $e");
    }
  }

  Future<void> rejectBooking({required String id}) async {
    try {
      loadingProgressIndicator();
      final response = await NetworkCaller().patchRequest(
        AppUrls.rejectBooking(id),
        body: {},
      );
      await hideProgressIndicator();
      if (response.isSuccess) {
        fetchOwnerBookings();
      } else {
        AppLoggerHelper.error("Error : ${response.responseData['message']}");
      }
    } catch (e) {
      await hideProgressIndicator();
      AppLoggerHelper.error("Error : $e");
    }
  }
}
