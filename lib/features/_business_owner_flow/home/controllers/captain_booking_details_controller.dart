import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_date_picker.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class CaptainBookingDetailsController extends GetxController {
  late String captainId;
  double basePrice = 300.0;

  // Form State
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final selectedBoatType = Rxn<String>();

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final List<String> boatTypes = [
    'MOTORBOAT',
    'CATAMARAN',
    'RIB',
    'JET_SKI',
    'GULET',
    'HOUSEBOAT'
  ];

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    captainId = args['captainId'] ?? '';
    basePrice = (args['price'] as num?)?.toDouble() ?? 300.0;
    log('CaptainBookingDetailsController onInit - captainId: $captainId, basePrice: $basePrice');
  }


  void selectStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    DateTime initial = startDate.value ?? today;
    if (initial.isBefore(today)) initial = today;

    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
      startDateController.text = DateFormat('yyyy-MM-dd').format(picked);

      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = picked;
        endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }
  }

  void selectEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    DateTime first = startDate.value ?? today;
    if (first.isBefore(today)) first = today;

    DateTime initial = endDate.value ?? first;
    if (initial.isBefore(first)) initial = first;

    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate.value = picked;
      endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void setSelectedBoatType(String? value) {
    selectedBoatType.value = value;
  }

  double get subTotal {
    if (startDate.value == null || endDate.value == null) return 0.0;
    int days = endDate.value!.difference(startDate.value!).inDays;
    if (days < 0) days = 0;
    days += 1; // inclusive of start day
    return basePrice * days;
  }

  double get serviceFee => subTotal > 0 ? 10.0 : 0.0;
  double get extraFee => subTotal > 0 ? 10.0 : 0.0;
  double get totalAmount => subTotal > 0 ? subTotal + serviceFee + extraFee : 0.0;

  Future<void> hireCaptain() async {
    if (startDate.value == null || endDate.value == null || selectedBoatType.value == null) {
      AppHelperFunctions.showSnackBar("Please fill in all fields.", isError: true);
      return;
    }

    if (captainId.isEmpty) {
      AppHelperFunctions.showSnackBar("Captain ID is missing.", isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final body = {
        "captainId": captainId,
        "boatType": selectedBoatType.value,
        "startDate": DateFormat('yyyy-MM-dd').format(startDate.value!),
        "endDate": DateFormat('yyyy-MM-dd').format(endDate.value!),
      };

      log('Hire Captain Request URL: ${AppUrls.hireCaptain}');
      log('Hire Captain Request Body: ${jsonEncode(body)}');

      // Use a direct HTTP call with a longer timeout (30s) since
      // Stripe checkout session creation can take longer than the
      // default 10s NetworkCaller timeout.
      final httpResponse = await http.post(
        Uri.parse(AppUrls.hireCaptain),
        headers: {
          'Authorization': 'Bearer ${StorageService.token ?? ''}',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      log('Hire Captain Response Status: ${httpResponse.statusCode}');
      log('Hire Captain Response Body: ${httpResponse.body}');

      final decodedResponse = jsonDecode(httpResponse.body);

      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        final data = decodedResponse['data'];
        if (data != null && data['url'] != null) {
          final url = data['url'] as String;
          log('Stripe Checkout URL received: $url');
          await _launchStripeUrl(url);
        } else {
          log('Payment URL not found in response: $decodedResponse');
          AppHelperFunctions.showSnackBar("Payment URL not found in response.", isError: true);
        }
      } else {
        // Try both 'message' and 'error' fields used by different APIs
        final errorMsg = decodedResponse['message'] ??
            decodedResponse['error'] ??
            'Request failed with status ${httpResponse.statusCode}';
        log('Hire Captain API Error: $errorMsg');
        AppHelperFunctions.showSnackBar(errorMsg.toString(), isError: true);
      }
    } catch (e) {
      log('Hire Captain Exception: $e');
      AppHelperFunctions.showSnackBar("Something went wrong: ${e.toString()}", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _launchStripeUrl(String urlString) async {
    log('Navigating to StripePaymentScreen with URL: $urlString');
    Get.toNamed(
      AppRoute.stripePaymentScreen,
      arguments: {'url': urlString},
    );
  }
}
