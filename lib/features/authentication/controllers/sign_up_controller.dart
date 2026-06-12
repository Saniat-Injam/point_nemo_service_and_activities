import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  // Stores the full international phone number (e.g. "+8801716559857")
  String completePhoneNumber = '';

  // Role received from the role-selection screen
  final role = 'USER'.obs;

  final NetworkCaller _networkCaller = NetworkCaller();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('role')) {
      role.value = args['role'] as String;
    }
    // Restore persisted Remember Me state so the checkbox reflects
    // the user's last choice even on the sign-up screen.
    rememberMe.value = StorageService.rememberMe;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> signUp() async {
    final String fullName = fullNameController.text.trim();
    final String phone = completePhoneNumber.isNotEmpty
        ? completePhoneNumber
        : phoneController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // --- Validation ---
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final Map<String, dynamic> body = {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phone,
      'password': password,
      'role': role.value,
      'logInProcess': 'EMAIL',
      'keepMeLogin': rememberMe.value,
      'fcmToken': 'optional_fcm_token',
    };

    try {
      final response = await _networkCaller.postRequest(
        AppUrls.signup,
        body: body,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        // Persist Remember Me preference so the login screen picks it up
        // when the user is redirected there after OTP verification.
        await StorageService.saveRememberMe(
          rememberMe: rememberMe.value,
          identifier: email,
          loginMethod: 'email',
          password: password,
        );

        // The server may nest the payload under 'data' or return it at the top level
        final responseData = response.responseData as Map<String, dynamic>;
        final data = (responseData['data'] is Map<String, dynamic>)
            ? responseData['data'] as Map<String, dynamic>
            : responseData;

        // The user info might be nested under 'user' inside 'data'
        final user = (data['user'] is Map<String, dynamic>)
            ? data['user'] as Map<String, dynamic>
            : data;

        // Pass signup data forward so downstream screens (OTP, etc.) can use it
        Get.toNamed(
          AppRoute.chooseVerificationScreen,
          arguments: {
            'otpId': data['otpId'] ?? user['otpId'],
            'email': user['email'] ?? data['email'] ?? email,
            'phoneNumber': user['phoneNumber'] ?? data['phoneNumber'] ?? phone,
            'fullName': user['fullName'] ?? data['fullName'] ?? fullName,
            // Carry the selected role forward through the entire verification flow
            'role': role.value,
          },
        );
      } else {
        // Try 'message' key in response body first, then fall back to errorMessage
        String serverMessage = response.errorMessage;
        if (response.responseData is Map) {
          serverMessage =
              response.responseData['message']?.toString() ??
              response.responseData['error']?.toString() ??
              response.errorMessage;
        }
        AppHelperFunctions.showSnackBar(
          serverMessage.isNotEmpty
              ? serverMessage
              : 'Sign up failed. Please try again.',
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('SignUp Error: $e');
      AppHelperFunctions.showSnackBar(
        'Sign up failed. Please check your details and try again.',
      );
    }
  }

  void navigateToSignIn() {
    Get.toNamed(AppRoute.loginScreen);
  }

}
