import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class ChooseVerificationController extends GetxController {
  final selectedMode = 'email'.obs;

  void selectMode(String mode) {
    selectedMode.value = mode;
  }

  void submit() {
    final args = Map<String, dynamic>.from(Get.arguments ?? {});
    args['mode'] = selectedMode.value;

    Get.toNamed(AppRoute.otpVerificationScreen, arguments: args);
  }
}
