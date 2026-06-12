import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'package:point_nemo_service_and_activities/features/authentication/controllers/otp_verification_controller.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpVerificationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // Header with back button and title
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
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      controller.title,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 24.h),

              // Subtitle
              Text(
                controller.subtitle,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 32.h),

              // OTP input fields
              Pinput(
                length: 6,
                controller: controller.otpController,
                focusNode: controller.focusNode,
                defaultPinTheme: PinTheme(
                  width: 48.w,
                  height: 48.w,
                  textStyle: getTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1B20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.w),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 48.w,
                  height: 48.w,
                  textStyle: getTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1B20),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.w),
                    border: Border.all(
                      color: const Color(0xFF040A18),
                      width: 1.5,
                    ),
                  ),
                ),
                onCompleted: (pin) {
                  // Optional: verify automatically on complete
                  // controller.verifyOtp();
                },
              ),
              SizedBox(height: 16.h),

              // Timer
              Obx(
                () => Text(
                  controller.formattedTime,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
              ),

              const Spacer(),

              // Resend code text
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.didntReceiveCode,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    controller.isResendLoading.value
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF2972FF),
                            ),
                          )
                        : GestureDetector(
                            onTap: controller.canResend.value
                                ? controller.resendCode
                                : null,
                            child: Text(
                              AppLocalizations.of(context)!.resendCode,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: controller.canResend.value
                                    ? const Color(0xFF2972FF)
                                    : const Color(0xFFB0B8C1),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Verify button
              Obx(
                () => CustomSubmitButton(
                  text: controller.isLoading.value ? AppLocalizations.of(context)!.verifying : AppLocalizations.of(context)!.verify,
                  onTap: controller.isLoading.value
                      ? () {}
                      : controller.verifyOtp,
                  color: const Color(0xFF040A18),
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(28.w),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
