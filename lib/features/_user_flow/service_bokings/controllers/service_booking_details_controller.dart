import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_date_picker.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class ServiceBookingDetailsController extends GetxController {
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final isBoatRental = false.obs;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final guestsController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  // Service info passed via arguments
  String _serviceId = '';
  final pricePerDay = 0.0.obs;

  /// Number of days between startDate and endDate (inclusive).
  /// Returns 0 if dates have not been selected yet.
  int get numberOfDays {
    if (startDate.value == null || endDate.value == null) return 0;
    final diff = endDate.value!.difference(startDate.value!).inDays + 1; // inclusive of both start and end
    return diff < 1 ? 1 : diff;
  }

  double get subtotal => pricePerDay.value * numberOfDays;
  double get total => subtotal;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['type'] != null) {
        isBoatRental.value = args['type'] == 'BOAT_RENTAL';
      }
      if (args['serviceId'] != null) {
        _serviceId = args['serviceId'] as String;
      }
      if (args['price'] != null) {
        pricePerDay.value = (args['price'] as num).toDouble();
      }
    }
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

  /// Validates form fields and POSTs a booking to the server.
  /// On success, navigates to [StripePaymentScreen] with the checkout URL.
  Future<void> submitBooking() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (startDate.value == null || endDate.value == null) {
      // Just a fallback in case raw text was modified but not values
      return;
    }

    if (_serviceId.isEmpty) {
      AppHelperFunctions.showSnackBar('Service ID is missing.', isError: true);
      return;
    }

    // Capacity defaults to 1; for boat rentals the user enters guest count
    int capacityRequest = 1;
    if (isBoatRental.value) {
      final raw = int.tryParse(guestsController.text.trim());
      if (raw == null || raw < 1) {
        return;
      }
      capacityRequest = raw;
    }

    isLoading.value = true;
    try {
      final body = {
        'serviceId': _serviceId,
        'startDate': DateFormat('yyyy-MM-dd').format(startDate.value!),
        'endDate': DateFormat('yyyy-MM-dd').format(endDate.value!),
        'capacityRequest': capacityRequest,
        'additionalServiceIds': <String>[],
      };

      log('Service Booking Request URL: ${AppUrls.createBooking}');
      log('Service Booking Request Body: ${jsonEncode(body)}');

      // Use a direct HTTP call with a longer timeout (30s) since
      // Stripe checkout session creation can take longer than the
      // default 10s NetworkCaller timeout.
      final httpResponse = await http
          .post(
            Uri.parse(AppUrls.createBooking),
            headers: {
              'Authorization': 'Bearer ${StorageService.token ?? ''}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      log('Service Booking Response Status: ${httpResponse.statusCode}');
      log('Service Booking Response Body: ${httpResponse.body}');

      final decoded = jsonDecode(httpResponse.body) as Map<String, dynamic>;

      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        final data = decoded['data'] as Map<String, dynamic>?;
        final url = data?['url'] as String?;
        if (url != null && url.isNotEmpty) {
          log('Stripe Checkout URL received: $url');
          Get.toNamed(
            AppRoute.stripePaymentScreen,
            arguments: {
              'url': url,
              'successMessage': 'Booking confirmed! Payment successful.',
              'cancelMessage': 'Payment was cancelled.',
            },
          );
        } else {
          AppHelperFunctions.showSnackBar('Payment URL not found in response.', isError: true);
        }
      } else {
        final errorMsg = decoded['message'] ??
            decoded['error'] ??
            'Request failed with status ${httpResponse.statusCode}';
        AppHelperFunctions.showSnackBar(errorMsg.toString(), isError: true);
      }
    } catch (e) {
      log('Service Booking Exception: $e');
      AppHelperFunctions.showSnackBar('Something went wrong: ${e.toString()}', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    guestsController.dispose();
    super.onClose();
  }
}
