import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/profile_setup_alert_dialog.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_snackbar.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';

class ProfileSetupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final selectedGender = ''.obs;

  final ImagePicker _picker = ImagePicker();

  RxBool isLoadingProfile = false.obs;
  RxBool isUpdatingProfile = false.obs;

  RxString profileImagePath = ''.obs;
  RxString nidImagePath = ''.obs;
  RxList<String> docsImagePaths = <String>[].obs;

  // Dummy observables for images (in a real app, these would be File or XFile)
  final profileImageSelected = false.obs;
  final nidImageSelected = false.obs;
  final docsImageSelected = false.obs;

  int roleIndex = 0;
  bool isGuest = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    log('📋 ProfileSetupController: token=${StorageService.token}, role=${StorageService.role}');

    // 1. Try from StorageService (populated after OTP verify or Login)
    final String? persistedRole = StorageService.role;
    if (persistedRole != null && persistedRole.isNotEmpty) {
      log('📋 Using persisted role: $persistedRole');
      _setRoleIndex(persistedRole);
    } else {
      // 2. Fallback: try from arguments (passed through signup chain)
      final String? roleStr = args['role'] as String?;
      if (roleStr != null) {
        log('📋 Using argument role: $roleStr');
        _setRoleIndex(roleStr);
      } else {
        // 3. Last fallback: legacy index
        roleIndex = args['roleIndex'] ?? 0;
        log('📋 Falling back to roleIndex: $roleIndex');
      }
    }
    isGuest = args['isGuest'] ?? false;
    fetchUserProfile();
  }

  void _setRoleIndex(String roleStr) {
    switch (roleStr.toUpperCase()) {
      case 'BUSINESS_OWNER':
        roleIndex = 1;
        break;
      case 'CAPTAIN':
        roleIndex = 2;
        break;
      default:
        roleIndex = 0;
    }
  }

  Future<void> fetchUserProfile() async {
    isLoadingProfile.value = true;
    try {
      final response = await NetworkCaller().getRequest(AppUrls.getMe);
      if (response.isSuccess && response.responseData is Map) {
        final responseMap = response.responseData as Map;
        // Handle both 'result' → 'data' and flat 'data' response shapes
        final result = responseMap['result'];
        final Map data =
            (result is Map ? result['data'] : null) ??
            responseMap['data'] ??
            {};
        fullNameController.text = data['fullName'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phoneNumber'] ?? '';
      } else if (!response.isSuccess) {
        CustomSnackBar.showError(
          message: response.errorMessage.isEmpty
              ? "Failed to load profile"
              : response.errorMessage,
        );
      }
    } finally {
      isLoadingProfile.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void setGender(String value) {
    selectedGender.value = value;
  }

  Future<void> pickProfileImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path;
      profileImageSelected.value = true;
    }
    Get.back(); // close bottom sheet
  }

  Future<void> takeProfilePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      profileImagePath.value = image.path;
      profileImageSelected.value = true;
    }
    Get.back(); // close bottom sheet
  }

  Future<void> pickNidImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      nidImagePath.value = image.path;
      nidImageSelected.value = true;
    }
  }

  Future<void> takeNidPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      nidImagePath.value = image.path;
      nidImageSelected.value = true;
    }
  }

  Future<void> pickDocsImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      docsImagePaths.value = result.paths.whereType<String>().toList();
      docsImageSelected.value = docsImagePaths.isNotEmpty;
    }
  }

  Future<void> takeDocsPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      docsImagePaths.add(image.path);
      docsImageSelected.value = true;
    }
  }

  Future<void> submitProfile() async {
    if (fullNameController.text.isEmpty) {
      CustomSnackBar.showError(message: "Please enter full name");
      return;
    }

    String roleStr;
    switch (roleIndex) {
      case 1:
        roleStr = 'BUSINESS_OWNER';
        break;
      case 2:
        roleStr = 'CAPTAIN';
        break;
      case 0:
      default:
        roleStr = 'USER';
        break;
    }

    Map<String, dynamic> requestBody = {
      "fullName": fullNameController.text.trim(),
      "gender": selectedGender.isNotEmpty
          ? selectedGender.value.toUpperCase()
          : "MALE",
      "location": {"long": "90.4302855", "lat": "23.761041"},
      "address": locationController.text.trim().isEmpty
          ? "address"
          : locationController.text.trim(),
      "role": roleStr,
    };

    Map<String, String> singleFiles = {};
    if (profileImagePath.value.isNotEmpty) {
      singleFiles['profileImage'] = profileImagePath.value;
    }
    if (nidImagePath.value.isNotEmpty) {
      singleFiles['nidUrl'] = nidImagePath.value;
    }

    Map<String, List<String>> multiFiles = {};
    if (docsImagePaths.isNotEmpty) {
      multiFiles['documents'] = docsImagePaths.toList();
    }

    isUpdatingProfile.value = true;
    try {
      final response = await NetworkCaller().multiFormApiCall(
        apiUrl: AppUrls.updateUser,
        method: 'PATCH',
        requestBody: requestBody,
        singleFiles: singleFiles.isNotEmpty ? singleFiles : null,
        multiFiles: multiFiles.isNotEmpty ? multiFiles : null,
      );

      if (response.isSuccess) {
        // Refresh token to get the updated role claims if the backend just updated our role.
        await StorageService.refreshAccessToken();
        
        if (roleIndex == 1) {
          Get.toNamed(AppRoute.registerBoatScreen);
        } else {
          Get.dialog(
            const ProfileSetupAlertDialog(),
            barrierDismissible: false,
          );
        }
      } else {
        CustomSnackBar.showError(
          message: response.errorMessage.isEmpty
              ? "Failed to update profile"
              : response.errorMessage,
        );
      }
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  void onDonePressed() {
    // Map roleIndex to role string
    // 0 -> User, 1 -> Business Owner, 2 -> Captain
    String role;
    switch (roleIndex) {
      case 1:
        role = 'BUSINESS_OWNER';
        break;
      case 2:
        role = 'CAPTAIN';
        break;
      case 0:
      default:
        role = 'USER';
        break;
    }

    final bool showVerificationPending = role != 'USER';

    // Navigate to Home with verification pending flag
    Get.offAllNamed(
      AppRoute.mainBottomNavBar,
      arguments: {
        'role': role,
        'isGuest': isGuest,
        'showVerificationPending': showVerificationPending,
      },
    );
  }
}
