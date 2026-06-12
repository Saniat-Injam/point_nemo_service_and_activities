
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

class BusinessOwnerRejectBookingDialogue extends StatelessWidget {
  const BusinessOwnerRejectBookingDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.w)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Check icon in circle
            Container(
              width: 90.w,
              height: 90.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F5FA),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF040A18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 32.w),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              'Are You Sure You Want to\nCancel This Booking?',
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF374151),
                height: 1.3,
              ),
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Text(
              "Please confirm only if you don't wish to\ncontinue with this booking.",
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),

            // Button
            GestureDetector(
              onTap: () {
                // Return to previous screens (or execute reject logic)
                Get.back(); // Close dialog
                Get.back(); // Go back from reject screen
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF040A18),
                  borderRadius: BorderRadius.circular(30.w),
                ),
                child: Center(
                  child: Text(
                    'Ok Reject',
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
