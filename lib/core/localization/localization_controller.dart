import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';

class LocalizationController extends GetxController {
  static LocalizationController get instance => Get.find();

  // Observable locale
  var locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final savedLang = StorageService.language ?? 'en';
    locale.value = Locale(savedLang);
    // Defer locale update until after the first frame to avoid calling
    // markNeedsBuild during a build phase (triggered by GetMaterialApp
    // initialising bindings synchronously during its first build).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(locale.value);
    });
  }

  void changeLanguage(String languageCode) {
    locale.value = Locale(languageCode);
    StorageService.saveLanguage(languageCode);
    Get.updateLocale(locale.value);
  }
}
