import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/icon_path.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/features/.common/verification/verification_pending_widget.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/verification_pending_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VerificationPendingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                // Top Profile Header
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(ImagePath.captain),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              controller.userName.value,
                              style: getTextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF040A18),
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              controller.userRole.value,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.pending,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFA65F00),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(IconPath.notification),
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                // Verification Pending Card
                VerificationPendingWidget(
                  submissionDate: controller.submissionDate.value,
                  onSupportPressed: controller.onSupportPressed,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
