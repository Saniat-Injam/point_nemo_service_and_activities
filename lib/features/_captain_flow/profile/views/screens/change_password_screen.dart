// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
// import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
// import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
// import 'package:point_nemo_service_and_activities/features/_captain_flow/profile/controllers/profile_controller.dart';

// class ChangePasswordScreen extends StatelessWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Lazily instantiate or retrieve the ProfileController
//     final ProfileController controller = Get.find<ProfileController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'Change Password',
//         titleSize: 20.sp,
//         titleColor: AppColors.textPrimary,
//         backgroundColor: Colors.white,
//         showBackIcon: true,
//         borderRadius: 0,
//         enableShadow: false,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//           child: Column(
//             children: [
//               Obx(
//                 () => CustomTextFormField(
//                   controller: controller.newPasswordController,
//                   hintText: 'New Password',
//                   obscureText: controller.isNewPasswordObscured.value,
//                   containerColor: Colors.white,
//                   containerBorderColor: AppColors.textFormFieldBorder,
//                   borderRedius: 50.w,
//                   prefixIcon: Icon(
//                     Icons.lock_outline,
//                     color: AppColors.textSecondary,
//                     size: 24.w,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       controller.isNewPasswordObscured.value
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                       color: AppColors.textSecondary,
//                       size: 24.w,
//                     ),
//                     onPressed: controller.toggleNewPasswordVisibility,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Obx(
//                 () => CustomTextFormField(
//                   controller: controller.confirmPasswordController,
//                   hintText: 'Confirm Password',
//                   obscureText: controller.isConfirmPasswordObscured.value,
//                   containerColor: Colors.white,
//                   containerBorderColor: AppColors.textFormFieldBorder,
//                   borderRedius: 50.w,
//                   prefixIcon: Icon(
//                     Icons.lock_outline,
//                     color: AppColors.textSecondary,
//                     size: 24.w,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       controller.isConfirmPasswordObscured.value
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                       color: AppColors.textSecondary,
//                       size: 24.w,
//                     ),
//                     onPressed: controller.toggleConfirmPasswordVisibility,
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               CustomSubmitButton(
//                 text: 'Confirm',
//                 onTap: () {
//                   // Handle confirm
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
