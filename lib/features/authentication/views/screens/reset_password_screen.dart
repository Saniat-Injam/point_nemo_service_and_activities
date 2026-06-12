import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/features/authentication/controllers/reset_password_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetPasswordController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF1D1B20),
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    AppLocalizations.of(context)!.resetPassword,
                    style: getTextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // New Password
              Text(
                AppLocalizations.of(context)!.newPassword,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => CustomTextFormField(
                  controller: controller.newPasswordController,
                  hintText: AppLocalizations.of(context)!.enterPassword,
                  obscureText: controller.isNewPasswordObscured.value,
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: const Color(0xFF9CA3AF),
                        size: 20.w,
                      ),
                    ],
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordObscured.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF9CA3AF),
                      size: 20.w,
                    ),
                    onPressed: controller.toggleNewPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Confirm Password
              Text(
                AppLocalizations.of(context)!.confirmPassword,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => CustomTextFormField(
                  controller: controller.confirmPasswordController,
                  hintText: AppLocalizations.of(context)!.enterPassword,
                  obscureText: controller.isConfirmPasswordObscured.value,
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: const Color(0xFF9CA3AF),
                        size: 20.w,
                      ),
                    ],
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordObscured.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF9CA3AF),
                      size: 20.w,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 56.h),

              // Verify Button
              CustomSubmitButton(
                text: AppLocalizations.of(context)!.verify,
                onTap: controller.verify,
                color: const Color(0xFF040A18),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(28.w),
                padding: EdgeInsets.symmetric(vertical: 18.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
