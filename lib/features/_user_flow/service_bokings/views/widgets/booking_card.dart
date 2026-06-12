import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/user_booking_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BookingCard extends StatelessWidget {
  final UserBookingModel booking;
  final VoidCallback onCancel;
  final VoidCallback onRefundRequest;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onCancel,
    required this.onRefundRequest,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.bookingStatus;
    Color priceColor = AppColors.primary;
    if (status == BookingStatus.completed) {
      priceColor = const Color(0xFF00C853);
    } else if (status == BookingStatus.cancelled ||
        status == BookingStatus.rejected) {
      priceColor = const Color(0xFFEF4444);
    }
    log(status.toString());

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: booking.coverImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: booking.coverImage,
                        width: 110.w,
                        height: 110.h,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 110.w,
                          height: 110.h,
                          color: const Color(0xFFE5E7EB),
                          child: Icon(
                            Icons.image_outlined,
                            size: 32.w,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 110.w,
                          height: 110.h,
                          color: const Color(0xFFE5E7EB),
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 32.w,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      )
                    : Container(
                        width: 110.w,
                        height: 110.h,
                        color: const Color(0xFFE5E7EB),
                        child: Icon(
                          Icons.image_outlined,
                          size: 32.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      booking.title,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    // Category
                    Text(
                      booking.category,
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Date & Time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13.w,
                          color: const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booking.formattedDate,
                          style: getTextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF374151),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.access_time_outlined,
                          size: 13.w,
                          color: const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booking.startTime,
                          style: getTextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.w,
                          color: const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            booking.location,
                            style: getTextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF374151),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Price & Status
                    Row(
                      children: [
                        Text(
                          '\$${booking.price.toStringAsFixed(2)}',
                          style: getTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: priceColor,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _buildStatusBadge(context, status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status == BookingStatus.upcoming) ...[
            SizedBox(height: 14.h),
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(32.w),
                  onTap: onCancel,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.w),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancelText,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ] else if (status == BookingStatus.completed) ...[
            SizedBox(height: 14.h),
            const Divider(color: Color(0xFFE5E7EB), height: 1),
            SizedBox(height: 14.h),
            Row(
              children: [
                // Refund Request button
                Expanded(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.w),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32.w),
                      onTap: onRefundRequest,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.w),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5.w,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.refundRequestText,
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Review Now button
                Expanded(
                  child: Material(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(32.w),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32.w),
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      onTap: () {
                        Get.toNamed(
                          AppRoute.bookingReviewScreen,
                          arguments: booking,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 16.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              AppLocalizations.of(context)!.reviewNowText,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (status == BookingStatus.cancelled) ...[
            SizedBox(height: 14.h),
            const Divider(color: Color(0xFFE5E7EB), height: 1),
            SizedBox(height: 14.h),
            Center(
              child: Text(
                AppLocalizations.of(context)!.bookingCancelledText,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, BookingStatus status) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case BookingStatus.upcoming:
        text = AppLocalizations.of(context)!.upcomingText;
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF374151);
        break;
      case BookingStatus.completed:
        text = AppLocalizations.of(context)!.completedText;
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        break;
      case BookingStatus.cancelled || BookingStatus.rejected:
        text = AppLocalizations.of(context)!.cancelText;
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Text(
        text,
        style: getTextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
