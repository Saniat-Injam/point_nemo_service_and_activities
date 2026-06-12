import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final timerSeconds = 90.obs;
  final canResend = false.obs;
  final isLoading = false.obs;
  final isResendLoading = false.obs;
  Timer? _timer;

  late String mode;
  late String email;
  late String phoneNumber;

  final NetworkCaller _networkCaller = NetworkCaller();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    mode = args?['mode'] ?? 'phone';
    email = args?['email'] ?? '';
    phoneNumber = args?['phoneNumber'] ?? '';
    startTimer();
  }

  void startTimer() {
    timerSeconds.value = 90;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    final minutes = timerSeconds.value ~/ 60;
    final seconds = timerSeconds.value % 60;
    return '$minutes.${seconds.toString().padLeft(2, '0')}';
  }

  String get title =>
      mode == 'phone' ? 'Verify Your Phone\nNumber' : 'Verify Your Email';

  String get subtitle => mode == 'phone'
      ? 'Please enter the 6-digit code we sent to your\n$phoneNumber'
      : 'Please enter the 6-digit code we sent to your\n$email';

  Future<void> resendCode() async {
    if (!canResend.value || isResendLoading.value) return;

    final args = Get.arguments as Map<String, dynamic>?;
    final isFromForgetPassword = args?['isFromForgetPassword'] ?? false;

    final String purpose;
    if (isFromForgetPassword) {
      purpose = 'PASSWORD_RESET';
    } else if (mode == 'email') {
      purpose = 'EMAIL_VERIFICATION';
    } else {
      purpose = 'PHONE_VERIFICATION';
    }

    final String identifier = (mode == 'email') ? email : phoneNumber;

    isResendLoading.value = true;

    final response = await _networkCaller.postRequest(
      AppUrls.resendOtp,
      body: {'identifier': identifier, 'purpose': purpose},
    );

    isResendLoading.value = false;

    if (response.isSuccess) {
      startTimer();
      AppHelperFunctions.showSnackBar('OTP resent successfully');
    } else {
      final serverMessage =
          (response.responseData is Map &&
              response.responseData['message'] != null)
          ? response.responseData['message'].toString()
          : response.errorMessage;
      AppHelperFunctions.showSnackBar(
        serverMessage.isNotEmpty
            ? serverMessage
            : 'Failed to resend OTP. Please try again.',
      );
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      AppHelperFunctions.showSnackBar('Please enter the 6-digit code');
      return;
    }

    // Determine the purpose based on the mode and whether it's a password reset
    final args = Get.arguments as Map<String, dynamic>?;
    final isFromForgetPassword = args?['isFromForgetPassword'] ?? false;

    final String purpose;
    if (isFromForgetPassword) {
      purpose = 'PASSWORD_RESET';
    } else if (mode == 'email') {
      purpose = 'EMAIL_VERIFICATION';
    } else {
      purpose = 'PHONE_VERIFICATION';
    }

    // The identifier is either email (email mode) or phone number (phone mode)
    final String identifier = (mode == 'email') ? email : phoneNumber;

    isLoading.value = true;

    final response = await _networkCaller.postRequest(
      AppUrls.verifyOtp,
      body: {'identifier': identifier, 'code': otp, 'purpose': purpose},
    );

    isLoading.value = false;

    if (response.isSuccess) {
      if (!isFromForgetPassword && response.responseData is Map) {
        final responseMap = response.responseData as Map;
        log('🔑 verify-otp full response: $responseMap');
        // Support both nested 'result' and 'data' response shapes
        final resultData =
            responseMap['result'] ?? responseMap['data'] ?? responseMap;
        log('🔑 resultData: $resultData');
        if (resultData is Map) {
          final accessToken = resultData['accessToken'] as String?;
          final refreshToken = resultData['refreshToken'] as String?;
          final user = (resultData['user'] ?? {}) as Map;
          log('🔑 accessToken found: $accessToken');
          if (accessToken != null && accessToken.isNotEmpty) {
            // Prefer the role the user chose during sign-up (passed via args)
            // over whatever the OTP-verify API response returns, because the
            // server may return 'USER' for all new accounts regardless of role.
            final String chosenRole = (args?['role'] as String?)?.toUpperCase() ?? '';
            final String apiRole = (resultData['role'] ?? user['role'] ?? '').toString().toUpperCase();
            final String roleToSave = chosenRole.isNotEmpty ? chosenRole : (apiRole.isNotEmpty ? apiRole : 'USER');
            log('🔑 Role to save: $roleToSave (chosen: $chosenRole, api: $apiRole)');
            await StorageService.saveToken(
              token: accessToken,
              refreshToken: refreshToken,
              id: (user['id'] ?? user['_id'] ?? resultData['id'] ?? resultData['_id'] ?? '').toString(),
              role: roleToSave,
            );
            log(
              '✅ Token saved. StorageService.token = ${StorageService.token}, StorageService.role = ${StorageService.role}',
            );
          } else {
            log('⚠️ No accessToken found in response. Cannot save token.');
          }
        }
      }

      if (isFromForgetPassword) {
        Get.toNamed(AppRoute.resetPasswordScreen);
      } else {
        Get.toNamed(AppRoute.successScreen, arguments: args);
      }
    } else {
      final serverMessage =
          (response.responseData is Map &&
              response.responseData['message'] != null)
          ? response.responseData['message'].toString()
          : response.errorMessage;
      AppHelperFunctions.showSnackBar(
        serverMessage.isNotEmpty
            ? serverMessage
            : 'OTP verification failed. Please try again.',
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
