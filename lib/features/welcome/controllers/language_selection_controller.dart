import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/localization/localization_controller.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class LanguageSelectionController extends GetxController {
  // Selected language: 'en' for English, 'ar' for Arabic
  final selectedLanguage = 'en'.obs;

  // Language options
  final languages = [
    {'code': 'en', 'name': 'English', 'flag': 'assets/images/usa_flag.png'},
    {'code': 'ar', 'name': 'Arabic', 'flag': 'assets/images/arabic_flag.png'},
  ];

  void selectLanguage(String code) {
    selectedLanguage.value = code;
    // Apply locale immediately so UI text updates in real time on this screen
    LocalizationController.instance.changeLanguage(code);
  }

  void onContinue() {
    // Language is already persisted by LocalizationController.changeLanguage()
    Get.offAllNamed(AppRoute.onboardingScreen);
  }
}
