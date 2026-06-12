import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/controllers/business_owner_booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/views/screens/business_owner_reject_booking_screen.dart';

class BookingRejectBottomSheet extends StatelessWidget {
  const BookingRejectBottomSheet({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 12.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom
            : 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.w),
          topRight: Radius.circular(24.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 45.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4.w),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          Text(
            'Want to cancel your Booking?',
            style: getTextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF040A18),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),

          // Subtitle
          Text(
            'Are you sure you want to cancel your booking? Please\nselect a reason so we can improve your experience.',
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 36.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.w),
                      border: Border.all(
                        color: const Color(0xFF040A18),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Go Back',
                        style: getTextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF040A18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back(); // close the bottom sheet
                    // Get.to(() => const BusinessOwnerRejectBookingScreen());
                    final controller =
                        Get.find<BusinessOwnerBookingController>();
                    controller.rejectBooking(id: id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF040A18),
                      borderRadius: BorderRadius.circular(30.w),
                      border: Border.all(
                        color: const Color(0xFF040A18),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Reject Order',
                        style: getTextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
