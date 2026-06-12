import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/features/authentication/controllers/forget_password_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ForgetPasswordEmailScreen extends StatelessWidget {
  const ForgetPasswordEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();

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
                    AppLocalizations.of(context)!.forgotPassword,
                    style: getTextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                AppLocalizations.of(context)!.forgotPasswordEmailSub,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 32.h),

              // Email label
              Text(
                AppLocalizations.of(context)!.emailAddress,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: controller.emailController,
                hintText: AppLocalizations.of(context)!.enterEmail,
                keyboardType: TextInputType.emailAddress,
                containerColor: Colors.white,
                containerBorderColor: const Color(0xFFE5E7EB),
                borderRedius: 28.w,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: const Color(0xFF9CA3AF),
                      size: 20.w,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Continue Button with loading state
              Obx(() {
                final loading = controller.isLoading.value;
                return CustomSubmitButton(
                  text: AppLocalizations.of(context)!.sendOtp,
                  onTap: loading ? () {} : controller.sendOtpViaEmail,
                  color: loading
                      ? const Color(0xFF040A18).withValues(alpha: 0.6)
                      : const Color(0xFF040A18),
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(28.w),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: loading
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
