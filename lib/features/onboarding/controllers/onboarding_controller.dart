import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/onboarding/models/onboarding_model.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  // Controllers
  final imagePageController = PageController();
  final textPageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      imagePath: ImagePath.onboarding1,
      title: "Rent Boats",
      subtitle:
          "Choose from yachts, speed boats, and sail boats\nfor your perfect water adventure",
    ),
    OnboardingModel(
      imagePath: ImagePath.onboarding2,
      title: "Water Sports",
      subtitle:
          "Experience jet skiing, surfing, parasailing and\nmore exciting water activities",
    ),
    OnboardingModel(
      imagePath: ImagePath.onboarding3,
      title: "Diving & Snorkeling",
      subtitle:
          "Explore underwater worlds with professional\ncourses and guided experiences",
    ),
    OnboardingModel(
      imagePath: ImagePath.onboarding4,
      title: "Fishing Trips",
      subtitle:
          "Join organized fishing expeditions with all\nequipment provided",
    ),
    OnboardingModel(
      imagePath: ImagePath.onboarding5,
      title: "Hire Captains",
      subtitle:
          "Book experienced professional captains for your\nmaritime journey",
    ),
  ];

  void updatePageIndicator(int index) => currentPageIndex.value = index;

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    imagePageController.jumpToPage(index);
    textPageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndex.value == pages.length - 1) {
      // Go to Login Screen
      Get.offAllNamed(AppRoute.loginScreen);
    } else {
      int page = currentPageIndex.value + 1;
      imagePageController.jumpToPage(page);
      textPageController.jumpToPage(page);
    }
  }

  void skipPage() {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  @override
  void onClose() {
    imagePageController.dispose();
    textPageController.dispose();
    super.onClose();
  }
}
