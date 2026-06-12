import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/features/authentication/controllers/success_controller.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SuccessController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success illustration
              Image.asset(
                ImagePath.success,
                width: 220.w,
                height: 220.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 32.h),

              // Title
              Text(
                controller.isFromResetPassword
                    ? AppLocalizations.of(context)!.successResetPassword
                    : AppLocalizations.of(context)!.successCreateAccount,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1B20),
                ),
              ),

              const Spacer(flex: 3),

              // Continue Profile Setup button
              CustomSubmitButton(
                text: controller.isFromResetPassword
                    ? AppLocalizations.of(context)!.goToSignIn
                    : AppLocalizations.of(context)!.continueProfileSetup,
                onTap: controller.navigateNext,
                color: const Color(0xFF040A18),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(28.w),
                padding: EdgeInsets.symmetric(vertical: 18.h),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
