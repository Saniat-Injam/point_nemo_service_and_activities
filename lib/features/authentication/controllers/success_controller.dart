import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class SuccessController extends GetxController {
  bool get isFromResetPassword {
    final args = Get.arguments as Map<String, dynamic>?;
    return args?['isFromResetPassword'] ?? false;
  }

  void navigateNext() {
    if (isFromResetPassword) {
      Get.offAllNamed(AppRoute.loginScreen);
    } else {
      Get.toNamed(AppRoute.profileSetupScreen, arguments: Get.arguments);
    }
  }
}
