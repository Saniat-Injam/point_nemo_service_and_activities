import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class VerificationPendingController extends GetxController {
  final userName = 'Alturki'.obs;
  final userRole = 'Captain'.obs;
  final submissionDate = 'April 24, 2025'.obs;

  late final String _role;

  @override
  void onInit() {
    super.onInit();
    // Read role from arguments or fall back to stored role
    final args = Get.arguments as Map<String, dynamic>?;
    _role = (args?['role'] as String?) ??
        StorageService.role ??
        'USER';

    // Navigate to the correct home screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(
        AppRoute.mainBottomNavBar,
        arguments: {'role': _role.toUpperCase(), 'isGuest': false},
      );
    });
  }

  void onNotificationPressed() {
    // Handle notification
  }

  void onSupportPressed() {
    // Handle support
  }
}
