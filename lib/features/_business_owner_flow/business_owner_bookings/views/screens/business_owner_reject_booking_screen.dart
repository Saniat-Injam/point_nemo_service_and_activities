import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/controllers/business_owner_reject_booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/views/widgets/business_owner_reject_booking_dialogue.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BusinessOwnerRejectBookingScreen extends StatelessWidget {
  const BusinessOwnerRejectBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessOwnerRejectBookingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.rejectBooking,
        titleSize: 20.sp,
        titleColor: const Color(0xFF040A18),
        backgroundColor: Colors.white,
        centerTitle: true,
        showBackIcon: true,
        enableShadow: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                AppLocalizations.of(context)!.reasonForCancellation,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF040A18),
                ),
              ),
              SizedBox(height: 16.h),
              const Divider(
                color: Color(0xFFE5E7EB),
                thickness: 1,
                height: 1, // Minimize extra spacing
              ),
              SizedBox(height: 20.h),
              // Reasons list
              ...controller.reasons.map(
                (reason) => _buildReasonItem(reason, controller),
              ),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context)!.otherReasons,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF040A18),
                ),
              ),
              SizedBox(height: 12.h),
              // Text Area
              Container(
                height: 140.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.addReasonHere,
                    hintStyle: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                ),
              ),
              const Spacer(),
              // Submit Button
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    const BusinessOwnerRejectBookingDialogue(),
                    barrierDismissible: true,
                  );
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
                      AppLocalizations.of(context)!.submitText,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonItem(String reason, BusinessOwnerRejectBookingController controller) {
    return Obx(() {
      final isSelected = controller.selectedReasons.contains(reason);
      return GestureDetector(
        onTap: () => controller.toggleReason(reason),
        child: Container(
          color: Colors.transparent, // Ensures the whole row is clickable
          margin: EdgeInsets.only(bottom: 20.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Container(
                width: 22.w,
                height: 22.w,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: const Color(0xFF040A18),
                    width: 2.w,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Icon(
                          Icons.check,
                          size: 16.w,
                          color: const Color(0xFF040A18),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 14.w),
              // Reason Text
              Expanded(
                child: Text(
                  reason,
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF040A18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
