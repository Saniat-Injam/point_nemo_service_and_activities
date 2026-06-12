// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProfileController extends GetxController {
//   // Edit Profile States
//   final nameController = TextEditingController(text: 'Jenny Wilson');
//   final emailController = TextEditingController(text: 'wilson@09gail.com');
//   final phoneController = TextEditingController(text: '308.555.0121');
//   final dobController = TextEditingController(text: 'November 24, 2000');
//   final locationController = TextEditingController();

//   final selectedGender = 'Male'.obs;

//   // Change Password States
//   final newPasswordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   final isNewPasswordObscured = true.obs;
//   final isConfirmPasswordObscured = true.obs;

//   // Language States
//   final selectedLanguage = 'English'.obs;

//   // Help & Support States
//   // Initialize with the first item expanded (index 0)
//   final expandedFaqIndices = <int>{0}.obs;

//   void toggleFaq(int index) {
//     if (expandedFaqIndices.contains(index)) {
//       expandedFaqIndices.remove(index);
//     } else {
//       expandedFaqIndices.add(index);
//     }
//   }

//   void toggleNewPasswordVisibility() {
//     isNewPasswordObscured.value = !isNewPasswordObscured.value;
//   }

//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
//   }

//   void setGender(String gender) {
//     selectedGender.value = gender;
//   }

//   void setLanguage(String language) {
//     selectedLanguage.value = language;
//   }

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     dobController.dispose();
//     locationController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
// }
