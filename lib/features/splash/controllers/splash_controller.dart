import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      _navigate();
    });
  }

  void _navigate() {
    if (StorageService.shouldAutoLogin) {
      // Remember Me is ON and a valid token exists — skip login entirely.
      final String role = (StorageService.role ?? 'USER')
          .toString()
          .toUpperCase();
      Get.offAllNamed(
        AppRoute.mainBottomNavBar,
        arguments: {'role': role, 'isGuest': false},
      );
    } else {
      // No persisted session — go to language / onboarding flow as usual.
      Get.offAllNamed(AppRoute.languageSelectionScreen);
    }
  }
}
