import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/apple_auth_service.dart';

class AppleAuthController extends GetxController {
  final isAppleLoading = false.obs;

  /// Triggers Apple Sign-In and calls the social sign-up/login API.
  /// [keepMeLogin] - matches the "Remember Me" toggle from the UI.
  /// [role] - optional role (USER/BUSINESS_OWNER/CAPTAIN) for new accounts.
  Future<void> signInWithApple({bool keepMeLogin = false, String? role}) async {
    if (isAppleLoading.value) return;

    isAppleLoading.value = true;
    try {
      await AppleAuthService.signInWithApple(
        keepMeLogin: keepMeLogin,
        role: role,
      );
    } finally {
      isAppleLoading.value = false;
    }
  }
}
