import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  final NetworkCaller _networkCaller = NetworkCaller();

  /// Called from the Email forgot-password screen.
  Future<void> sendOtpViaEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppHelperFunctions.showSnackBar('Please enter your email address');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppHelperFunctions.showSnackBar('Please enter a valid email address');
      return;
    }

    await _requestPasswordResetOtp(identifier: email, mode: 'email');
  }

  /// Called from the Phone forgot-password screen.
  Future<void> sendOtpViaPhone() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final phone = phoneController.text.trim();

    await _requestPasswordResetOtp(identifier: phone, mode: 'phone');
  }

  /// Shared logic: POSTs to /auth/forgot-password and navigates to OTP screen.
  Future<void> _requestPasswordResetOtp({
    required String identifier,
    required String mode,
  }) async {
    isLoading.value = true;

    final response = await _networkCaller.postRequest(
      AppUrls.forgotPassword,
      body: {'email': identifier},
    );

    isLoading.value = false;

    if (response.isSuccess) {
      // Extract data returned by the API
      final data = (response.responseData is Map)
          ? (response.responseData['data'] as Map<String, dynamic>? ?? {})
          : <String, dynamic>{};

      final String resolvedEmail = data['email']?.toString() ?? identifier;
      final String? expiresAt = data['expiresAt']?.toString();

      AppHelperFunctions.showSnackBar(
        response.responseData['message']?.toString() ?? 'OTP sent successfully',
      );

      Get.toNamed(
        AppRoute.otpVerificationScreen,
        arguments: {
          'isFromForgetPassword': true,
          'mode': mode,
          'email': resolvedEmail,
          'phoneNumber': mode == 'phone' ? identifier : '',
          if (expiresAt != null) 'expiresAt': expiresAt,
        },
      );
    } else {
      // Try to surface a meaningful message from the server
      final serverMessage =
          (response.responseData is Map &&
              response.responseData['message'] != null)
          ? response.responseData['message'].toString()
          : response.errorMessage;

      AppHelperFunctions.showSnackBar(
        serverMessage.isNotEmpty
            ? serverMessage
            : 'Failed to send OTP. Please try again.',
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
