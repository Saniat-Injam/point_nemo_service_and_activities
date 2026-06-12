import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/features/.common/nav_bar/controllers/nav_bar_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';

class UserHomeController extends GetxController {
  bool get isGuest {
    if (Get.isRegistered<NavBarController>()) {
      return Get.find<NavBarController>().isGuest.value;
    }
    return false;
  }

  String get userName {
    if (isGuest) return 'Guest User';
    if (Get.isRegistered<CommonProfileController>()) {
      final name = Get.find<CommonProfileController>().userName.value;
      return name.isEmpty ? 'User' : name;
    }
    return 'User';
  }

  String get userImage {
    if (isGuest) return '';
    if (Get.isRegistered<CommonProfileController>()) {
      return Get.find<CommonProfileController>().userProfileImage.value;
    }
    return '';
  }

  String get userLocalImage {
    if (isGuest) return '';
    if (Get.isRegistered<CommonProfileController>()) {
      return Get.find<CommonProfileController>().savedProfileImagePath.value;
    }
    return '';
  }

  void showGuestDialog() {
    if (Get.isRegistered<NavBarController>()) {
      Get.find<NavBarController>().changeIndex(
        0,
      ); // triggers guest dialog internally
    }
  }
}
