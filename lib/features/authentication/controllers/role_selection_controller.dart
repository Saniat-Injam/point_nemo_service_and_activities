import 'dart:developer';

import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/apple_auth_service.dart';
import 'package:point_nemo_service_and_activities/core/services/google_auth_service.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class RoleSelectionController extends GetxController {
  // Observable for selected role.
  // 0 -> User, 1 -> Business owner, 2 -> Captain
  var selectedRoleIndex = 0.obs;

  // Google sign-up flow state
  bool fromGoogle = false;
  String? googleEmail;
  String? googleName;
  String? googlePhotoUrl;
  bool keepMeLogin = false;

  // Apple sign-up flow state
  bool fromApple = false;
  String? appleEmail;
  String? appleName;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) return;

    // ── Google new-user flow ────────────────────────────────────────────────
    fromGoogle = args['fromGoogle'] as bool? ?? false;
    if (fromGoogle) {
      googleEmail = args['googleEmail'] as String?;
      googleName = args['googleName'] as String?;
      googlePhotoUrl = args['googlePhotoUrl'] as String?;
      keepMeLogin = args['keepMeLogin'] as bool? ?? false;
      log('RoleSelection: Google flow — email=$googleEmail');
      return;
    }

    // ── Apple new-user flow ─────────────────────────────────────────────────
    fromApple = args['fromApple'] as bool? ?? false;
    if (fromApple) {
      appleEmail = args['appleEmail'] as String?;
      appleName = args['appleName'] as String?;
      keepMeLogin = args['keepMeLogin'] as bool? ?? false;
      log('RoleSelection: Apple flow — email=$appleEmail');
      return;
    }

    // ── Standard flow (back-navigation role restore) ────────────────────────
    final prevRole = (args['previousRole'] as String?)?.toUpperCase();
    if (prevRole == 'BUSINESS_OWNER') {
      selectedRoleIndex.value = 1;
    } else if (prevRole == 'CAPTAIN') {
      selectedRoleIndex.value = 2;
    } else if (prevRole == 'USER') {
      selectedRoleIndex.value = 0;
    }
  }

  void selectRole(int index) {
    selectedRoleIndex.value = index;
  }

  /// Maps role index → API string
  String get selectedRole {
    switch (selectedRoleIndex.value) {
      case 1:
        return 'BUSINESS_OWNER';
      case 2:
        return 'CAPTAIN';
      default:
        return 'USER';
    }
  }

  /// Whether we are in any social sign-up flow (Google or Apple).
  bool get fromSocial => fromGoogle || fromApple;

  /// Called when the user taps "Continue" on the Role Selection screen.
  void onContinuePressed() {
    if (fromGoogle) {
      _continueWithGoogle();
    } else if (fromApple) {
      _continueWithApple();
    } else {
      // Standard email/phone sign-up flow
      Get.toNamed(AppRoute.signUpScreen, arguments: {'role': selectedRole});
    }
  }

  /// Completes the Google sign-up by calling the social API with the chosen role.
  Future<void> _continueWithGoogle() async {
    final email = googleEmail;
    if (email == null || email.isEmpty) {
      log('RoleSelection: googleEmail is missing — cannot proceed');
      return;
    }

    if (isLoading.value) return;
    isLoading.value = true;

    try {
      await GoogleAuthService.completeGoogleSignUp(
        googleEmail: email,
        role: selectedRole,
        fullName: googleName,
        profileImage: googlePhotoUrl,
        keepMeLogin: keepMeLogin,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Completes the Apple sign-up by calling the social API with the chosen role.
  Future<void> _continueWithApple() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      await AppleAuthService.completeAppleSignUp(
        appleEmail: appleEmail ?? '',
        role: selectedRole,
        fullName: appleName,
        keepMeLogin: keepMeLogin,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onGuestPressed() {
    Get.offAllNamed(
      AppRoute.mainBottomNavBar,
      arguments: {'isGuest': true, 'role': 'USER'},
    );
  }
}
