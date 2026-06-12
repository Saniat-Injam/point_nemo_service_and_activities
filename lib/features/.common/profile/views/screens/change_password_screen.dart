import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve shared CommonProfileController — never use Get.put() in screens
    final CommonProfileController controller = Get.find<CommonProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.changePassword,
        titleSize: 20.sp,
        titleColor: AppColors.textPrimary,
        backgroundColor: Colors.white,
        showBackIcon: true,
        borderRadius: 0,
        enableShadow: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Obx(
                () => CustomTextFormField(
                  controller: controller.oldPasswordController,
                  hintText: AppLocalizations.of(context)!.currentPassword,
                  obscureText: controller.isOldPasswordObscured.value,
                  containerColor: Colors.white,
                  containerBorderColor: AppColors.textFormFieldBorder,
                  borderRedius: 50.w,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 24.w,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isOldPasswordObscured.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 24.w,
                    ),
                    onPressed: controller.toggleOldPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => CustomTextFormField(
                  controller: controller.newPasswordController,
                  hintText: AppLocalizations.of(context)!.newPassword,
                  obscureText: controller.isNewPasswordObscured.value,
                  containerColor: Colors.white,
                  containerBorderColor: AppColors.textFormFieldBorder,
                  borderRedius: 50.w,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 24.w,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordObscured.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 24.w,
                    ),
                    onPressed: controller.toggleNewPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => CustomTextFormField(
                  controller: controller.confirmPasswordController,
                  hintText: AppLocalizations.of(context)!.confirmPassword,
                  obscureText: controller.isConfirmPasswordObscured.value,
                  containerColor: Colors.white,
                  containerBorderColor: AppColors.textFormFieldBorder,
                  borderRedius: 50.w,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 24.w,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordObscured.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 24.w,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              const Spacer(),
              Obx(
                () => controller.isChangingPassword.value
                    ? const CustomLoadingIndicator()
                    : CustomSubmitButton(
                        text: AppLocalizations.of(context)!.confirmAction,
                        onTap: controller.changePassword,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
