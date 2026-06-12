import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/google_auth_service.dart';

class GoogleAuthController extends GetxController {
  final isGoogleLoading = false.obs;

  /// Triggers Google Sign-In and calls the social sign-up/login API.
  /// [keepMeLogin] - matches the "Remember Me" toggle from the UI.
  /// [role] - optional role (USER/BUSINESS_OWNER) for new accounts.
  Future<void> signInWithGoogle({bool keepMeLogin = false, String? role}) async {
    if (isGoogleLoading.value) return;

    isGoogleLoading.value = true;
    try {
      await GoogleAuthService.signInWithGoogle(
        keepMeLogin: keepMeLogin,
        role: role,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
