import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundRequestController extends GetxController {
  final List<String> availableReasons = [
    'Booked by mistake',
    'Change of plans',
    'Wrong booking details',
    'Service not provided',
    'Payment issue',
  ];

  final RxList<String> selectedReasons = <String>[].obs;
  final TextEditingController otherReasonController = TextEditingController();

  void toggleReason(String reason) {
    if (selectedReasons.contains(reason)) {
      selectedReasons.remove(reason);
    } else {
      selectedReasons.add(reason);
    }
  }

  void submitRefundRequest() {
    // Implement API call or logical submission here
    Get.back();
    Get.snackbar(
      'Success',
      'Refund request submitted successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    otherReasonController.dispose();
    super.onClose();
  }
}
