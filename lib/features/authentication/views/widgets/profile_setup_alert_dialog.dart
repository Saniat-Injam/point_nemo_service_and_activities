import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/profile_setup_controller.dart';

class ProfileSetupAlertDialog extends StatelessWidget {
  const ProfileSetupAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImagePath.success,
              width: 180.w,
              height: 180.h,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150.w,
                height: 150.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F4FD),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: "Congratulations!",
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              textColor: AppColors.textPrimary,
            ),
            SizedBox(height: 12.h),
            CustomText(
              text:
                  "Your profile is successfully completed. You can do more changes.",
              textAlign: TextAlign.center,
              fontSize: 14.sp,
              textColor: AppColors.textSecondary,
            ),
            SizedBox(height: 32.h),
            CustomSubmitButton(
              text: "Done",
              onTap: () {
                final controller = Get.find<ProfileSetupController>();
                controller.onDonePressed();
              },
              borderRadius: BorderRadius.circular(26.w),
            ),
          ],
        ),
      ),
    );
  }
}
