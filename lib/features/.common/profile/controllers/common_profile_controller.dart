import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/models/user_profile_model.dart';
import 'package:point_nemo_service_and_activities/core/localization/localization_controller.dart';

class CommonProfileController extends GetxController {
  // ── API State ─────────────────────────────────────────────────────────────
  final _networkCaller = NetworkCaller();
  final isLoadingProfile = false.obs;
  final isUpdatingProfile = false.obs;

  // Observable user profile data (displayed on ProfileScreen)
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userProfileImage = ''.obs;
  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);

  // Profile image picking
  final ImagePicker _picker = ImagePicker();
  final profileImagePath = ''.obs;

  // Local path of successfully updated profile image (for immediate UI update)
  final savedProfileImagePath = ''.obs;

  // ── Edit Profile States ───────────────────────────────────────────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController(text: 'November 24, 2000');
  final locationController = TextEditingController();

  final selectedGender = 'Male'.obs;

  // ── Change Password States ────────────────────────────────────────────────
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isOldPasswordObscured = true.obs;
  final isNewPasswordObscured = true.obs;
  final isConfirmPasswordObscured = true.obs;
  final isChangingPassword = false.obs;

  // ── Language States ───────────────────────────────────────────────────────
  final selectedLanguage = 'en'.obs;

  // ── Help & Support States ─────────────────────────────────────────────────
  // Initialize with the first item expanded (index 0)
  final expandedFaqIndices = <int>{0}.obs;

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value =
        LocalizationController.instance.locale.value.languageCode;
    // Load cached profile data immediately for instant UI display
    final cachedImage = StorageService.profileImageUrl;
    final cachedName = StorageService.cachedUserName;
    final cachedPhone = StorageService.cachedPhoneNumber;
    if (cachedImage != null && cachedImage.isNotEmpty) {
      userProfileImage.value = cachedImage;
    }
    if (cachedName != null && cachedName.isNotEmpty) {
      userName.value = cachedName;
      nameController.text = cachedName;
    }
    if (cachedPhone != null && cachedPhone.isNotEmpty) {
      phoneController.text = cachedPhone;
      // Restore userProfile observer with the cached phone so the edit screen
      // correctly identifies the field as non-empty (read-only) on restart.
      userProfile.value = UserProfileModel(
        fullName: cachedName ?? '',
        email: '',
        phoneNumber: cachedPhone,
        profileImage: cachedImage ?? '',
        gender: '',
        address: '',
      );
    }
    fetchUserProfile();
  }

  // ── Fetch Profile (getMe) ─────────────────────────────────────────────────
  Future<void> fetchUserProfile() async {
    isLoadingProfile.value = true;
    try {
      final response = await _networkCaller.getRequest(AppUrls.getMe);
      if (response.isSuccess && response.responseData is Map) {
        _applyProfileData(response.responseData as Map);
      } else if (!response.isSuccess) {
        AppHelperFunctions.showSnackBar(
          response.errorMessage.isEmpty
              ? 'Failed to load profile'
              : response.errorMessage,
        );
      }
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path;
    }
  }

  // ── Update Profile (update-user) ──────────────────────────────────────────
  Future<void> updateUserProfile() async {
    if (nameController.text.trim().isEmpty) {
      AppHelperFunctions.showSnackBar('Full name cannot be empty');
      return;
    }

    final Map<String, dynamic> body = {
      'fullName': nameController.text.trim(),
      'gender': selectedGender.value.toUpperCase(),
      'address': locationController.text.trim().isEmpty
          ? 'address'
          : locationController.text.trim(),
      'location': {'long': '90.4302855', 'lat': '23.761041'},
    };

    if (phoneController.text.trim().isNotEmpty) {
      body['phoneNumber'] = phoneController.text.trim();
    }

    Map<String, String> singleFiles = {};
    if (profileImagePath.value.isNotEmpty) {
      singleFiles['profileImage'] = profileImagePath.value;
      print("File url : ${singleFiles['profileImage']}");
    }

    isUpdatingProfile.value = true;
    try {
      final response = await _networkCaller.multiFormApiCall(
        apiUrl: AppUrls.updateUser,
        method: 'PATCH',
        requestBody: body,
        singleFiles: singleFiles.isNotEmpty ? singleFiles : null,
      );

      if (response.isSuccess && response.responseData is Map) {
        // Clear network image cache for the specific URL to force reload next time
        if (userProfileImage.value.isNotEmpty) {
          CachedNetworkImage.evictFromCache(userProfileImage.value);
        }

        // Sync observables from the returned data
        final responseMap = response.responseData as Map;
        final dynamic rawData =
            responseMap['data'] ?? responseMap['result']?['data'];
        if (rawData is Map) {
          _applyProfileData(responseMap);
        }

        // Set the successfully saved local image for instant preview
        if (profileImagePath.value.isNotEmpty) {
          savedProfileImagePath.value = profileImagePath.value;
          // We can clear profileImagePath if it's meant only for picking logic,
          // but keeping it is fine as it's synced. Let's clear it down below or just keep it.
        }

        Get.back();
        CustomSnackBar.showSuccess(message: 'Profile updated successfully');
      } else {
        CustomSnackBar.showError(
          message: response.errorMessage.isEmpty
              ? 'Failed to update profile'
              : response.errorMessage,
        );
      }
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // ── Internal helper ───────────────────────────────────────────────────────
  void _applyProfileData(Map responseMap) {
    // Handles shapes: { result: { data: {...} } } and { data: {...} }
    final result = responseMap['result'];
    final Map<String, dynamic> data = Map<String, dynamic>.from(
      (result is Map ? result['data'] : null) ?? responseMap['data'] ?? {},
    );

    final profile = UserProfileModel.fromJson(data);

    // Merge new profile with existing data or current controller values to prevent empty overwrites
    final finalName = profile.fullName.isNotEmpty
        ? profile.fullName
        : nameController.text;
    final finalEmail = profile.email.isNotEmpty
        ? profile.email
        : emailController.text;
    final finalPhone = profile.phoneNumber.isNotEmpty
        ? profile.phoneNumber
        : phoneController.text;
    final finalImage = profile.profileImage.isNotEmpty
        ? profile.profileImage
        : userProfileImage.value;
    final finalGender = profile.gender.isNotEmpty
        ? profile.gender
        : selectedGender.value;
    final finalAddress = profile.address.isNotEmpty
        ? profile.address
        : locationController.text;

    userProfile.value = UserProfileModel(
      fullName: finalName,
      email: finalEmail,
      phoneNumber: finalPhone,
      profileImage: finalImage,
      gender: finalGender,
      address: finalAddress,
    );

    userName.value = finalName;
    userProfileImage.value = finalImage;
    userEmail.value = finalEmail;

    // Keep edit-profile text fields in sync
    nameController.text = finalName;
    emailController.text = finalEmail;
    phoneController.text = finalPhone;
    if (finalAddress.isNotEmpty) {
      locationController.text = finalAddress;
    }
    if (finalGender.isNotEmpty) {
      // API returns 'MALE'/'FEMALE'/'OTHER' — capitalise first letter only
      final g = finalGender;
      selectedGender.value = g[0].toUpperCase() + g.substring(1).toLowerCase();
    }

    // Persist profile image URL, name, and phone to local storage for instant load on restart
    StorageService.saveProfileCache(
      imageUrl: userProfileImage.value,
      name: userName.value,
      phoneNumber: finalPhone,
    );
  }

  // ── Change Password API ───────────────────────────────────────────────────
  Future<void> changePassword() async {
    final oldPwd = oldPasswordController.text.trim();
    final newPwd = newPasswordController.text.trim();
    final confirmPwd = confirmPasswordController.text.trim();

    if (oldPwd.isEmpty) {
      CustomSnackBar.showError(message: 'Current password cannot be empty');
      return;
    }
    if (newPwd.isEmpty) {
      CustomSnackBar.showError(message: 'New password cannot be empty');
      return;
    }
    if (newPwd != confirmPwd) {
      CustomSnackBar.showError(message: 'Passwords do not match');
      return;
    }

    isChangingPassword.value = true;
    try {
      final response = await _networkCaller.putRequest(
        AppUrls.changePassword,
        body: {'oldPassword': oldPwd, 'newPassword': newPwd},
      );
      if (response.isSuccess) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.back();
        CustomSnackBar.showSuccess(message: 'Password changed successfully');
      } else {
        CustomSnackBar.showError(
          message: response.errorMessage.isEmpty
              ? 'Failed to change password'
              : response.errorMessage,
        );
      }
    } finally {
      isChangingPassword.value = false;
    }
  }

  // ── Helper Methods ────────────────────────────────────────────────────────
  void toggleFaq(int index) {
    if (expandedFaqIndices.contains(index)) {
      expandedFaqIndices.remove(index);
    } else {
      expandedFaqIndices.add(index);
    }
  }

  void toggleOldPasswordVisibility() {
    isOldPasswordObscured.value = !isOldPasswordObscured.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordObscured.value = !isNewPasswordObscured.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    locationController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  final isDeleteLoading = false.obs;
  Future<void> deleteAccount() async {
    try {
      isDeleteLoading(true);
      final response = await NetworkCaller().deleteRequest(
        AppUrls.deleteAccount,
        'Bearer ${StorageService.token ?? ''}',
      );
      if (response.isSuccess) {
        CustomSnackBar.showSuccess(message: 'Account delete successful');
        StorageService.logoutUser();
      }
    } catch (e) {
      CustomSnackBar.showError(message: 'Error : $e');
    } finally {
      isDeleteLoading(false);
    }
  }
}
