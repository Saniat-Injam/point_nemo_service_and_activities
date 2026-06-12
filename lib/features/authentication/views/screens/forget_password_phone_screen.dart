import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_intl_phone_field.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/forget_password_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/utils/validators/app_validator.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
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
                  AppLocalizations.of(context)!.forgotPasswordPhoneSub,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 32.h),

                // Phone Number label
                Text(
                  AppLocalizations.of(context)!.phoneNumber,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomIntlPhoneField(
                  controller: controller.phoneController,
                  hintText: AppLocalizations.of(context)!.enterPhone,
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return AppValidator.validatePhoneNumber(null);
                    }
                    return AppValidator.validatePhoneNumber(phone.completeNumber);
                  },
                ),
                SizedBox(height: 32.h),

                // Send OTP button with loading state
                Obx(() {
                  final loading = controller.isLoading.value;
                  return CustomSubmitButton(
                    text: AppLocalizations.of(context)!.sendOtp,
                    onTap: loading ? () {} : controller.sendOtpViaPhone,
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
      ),
    );
  }
}
