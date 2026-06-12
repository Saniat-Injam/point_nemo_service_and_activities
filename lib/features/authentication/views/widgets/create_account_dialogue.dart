import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/logo_path.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

class CreateAccountDialog extends StatelessWidget {
  const CreateAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.w)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(32.w, 44.h, 32.w, 36.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 50,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.02),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ultra-Aesthetic Logo Container
            Container(
              height: 140.w,
              width: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.04),
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      LogoPath.outerCircle,
                      width: 95.w,
                      height: 95.w,
                      color: AppColors.primary.withValues(alpha: 0.9),
                    ),
                    Image.asset(
                      LogoPath.innerExclamation,
                      width: 14.w,
                      height: 42.w,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 36.h),
            Text(
              'Sign In Required',
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: -1.0,
                height: 1.1,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'To book boats or activities,\nplease create an account.',
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                height: 1.6,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 52.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.w),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: getTextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(AppRoute.loginScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: getTextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
