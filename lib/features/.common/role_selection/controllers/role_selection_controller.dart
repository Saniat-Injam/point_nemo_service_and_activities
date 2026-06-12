import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class RoleSelectionController extends GetxController {
  // Observable for selected role.
  // 0 -> User, 1 -> Business owner, 2 -> Captain
  var selectedRoleIndex = 0.obs;

  void selectRole(int index) {
    selectedRoleIndex.value = index;
  }

  void onContinuePressed() {
    // Navigate to Login Screen
    Get.toNamed(
      AppRoute.loginScreen,
      arguments: {'isGuest': false, 'roleIndex': selectedRoleIndex.value},
    );
  }

  void onGuestPressed() {
    // Guest navigation, currently defaults to login or home.
    Get.toNamed(
      AppRoute.loginScreen,
      arguments: {
        'isGuest': true,
        'roleIndex': 0, // Fallback to user role format if needed
      },
    );
  }
}


