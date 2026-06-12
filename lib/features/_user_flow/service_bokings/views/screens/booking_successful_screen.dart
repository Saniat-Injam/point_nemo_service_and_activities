import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BookingSuccessfulScreen extends StatelessWidget {
  const BookingSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 64.h),
            _buildIllustration(),
            SizedBox(height: 32.h),
            _buildTexts(context),
            SizedBox(height: 48.h),
            _buildDetailsCard(context),
            const Spacer(),
            _buildBottomButton(context),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Image.asset(
        ImagePath.success,
        width: 160.w,
        height: 160.w,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTexts(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.bookingConfirmedTitle,
          style: getTextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D1B20),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          AppLocalizations.of(context)!.bookingConfirmedSubtitle,
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.bookingDetails,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1D1B20),
            ),
          ),
          SizedBox(height: 24.h),
          _buildDetailRow(AppLocalizations.of(context)!.bookingIDText, 'BK26652429'),
          SizedBox(height: 16.h),
          _buildDetailRow(AppLocalizations.of(context)!.serviceText, 'Luxury Yacht Premium'),
          SizedBox(height: 16.h),
          _buildDetailRow(AppLocalizations.of(context)!.dateText, '2026-12-02'),
          SizedBox(height: 16.h),
          _buildDetailRow(AppLocalizations.of(context)!.timeText, '09:00'),
          SizedBox(height: 16.h),
          _buildDetailRow(AppLocalizations.of(context)!.location, 'Cox\'s Bazar'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4B5563),
          ),
        ),
        Text(
          value,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1B20),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        16.h,
        24.w,
        MediaQuery.of(context).padding.bottom > 0 ? 0 : 24.h,
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 0 : 16.h,
      ),
      child: GestureDetector(
        onTap: () {
          Get.offAllNamed(AppRoute.mainBottomNavBar);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1728),
            borderRadius: BorderRadius.circular(32.w),
          ),
          child: Text(
            AppLocalizations.of(context)!.viewMyBookings,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


