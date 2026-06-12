import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isEmailSelected = true.obs;
  final isPasswordObscured = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  final NetworkCaller _networkCaller = NetworkCaller();

  @override
  void onInit() {
    super.onInit();
    _loadRememberMeState();
  }

  /// Restores the persisted "Remember Me" checkbox and pre-fills the saved identifier.
  void _loadRememberMeState() {
    final bool saved = StorageService.rememberMe;
    if (saved) {
      rememberMe.value = true;
      final String? method = StorageService.savedLoginMethod;
      final String? identifier = StorageService.savedIdentifier;
      final String? password = StorageService.savedPassword;
      if (method == 'phone') {
        isEmailSelected.value = false;
        phoneController.text = identifier ?? '';
      } else {
        isEmailSelected.value = true;
        emailController.text = identifier ?? '';
      }
      if (password != null) {
        passwordController.text = password;
      }
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  void toggleLoginMethod(bool isEmail) {
    isEmailSelected.value = isEmail;
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login() async {
    // Determine the identifier based on selected login method
    final String identifier = isEmailSelected.value
        ? emailController.text.trim()
        : phoneController.text.trim();

    // Validate input
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final Map<String, dynamic> body = {
      'identifier': identifier,
      'password': passwordController.text,
      'keepMeLogin': rememberMe.value,
    };

    final response = await _networkCaller.postRequest(
      AppUrls.login,
      body: body,
    );

    if (response.isSuccess) {
      final data = response.responseData['data'];

      // Save auth data using StorageService
      await StorageService.saveToken(
        token: data['accessToken'],
        refreshToken: data['refreshToken'],
        id:
            ((data['user'] != null
                        ? data['user']['id'] ?? data['user']['_id']
                        : null) ??
                    data['id'] ??
                    data['_id'] ??
                    '')
                .toString(),
        role: data['role'],
      );

      // Persist or clear Remember Me preference
      await StorageService.saveRememberMe(
        rememberMe: rememberMe.value,
        identifier: identifier,
        loginMethod: isEmailSelected.value ? 'email' : 'phone',
        password: passwordController.text,
      );

      // The API already returns uppercase roles (USER, BUSINESS_OWNER, CAPTAIN)
      final String role = (data['role'] ?? 'USER').toString().toUpperCase();

      Get.offAllNamed(
        AppRoute.mainBottomNavBar,
        arguments: {'role': role, 'isGuest': false},
      );
    } else {
      AppHelperFunctions.showSnackBar(
        response.responseData['message'],
        isError: true,
      );
    }

    isLoading.value = false;
  }

  void continueAsGuest() {
    Get.offAllNamed(
      AppRoute.mainBottomNavBar,
      arguments: {'role': 'USER', 'isGuest': true},
    );
  }

  void navigateToSignUp() {
    Get.toNamed(AppRoute.roleSelectionScreen, arguments: Get.arguments);
  }
}
