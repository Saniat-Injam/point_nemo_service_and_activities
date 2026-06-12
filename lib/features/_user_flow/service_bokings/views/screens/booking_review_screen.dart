import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/booking_review_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BookingReviewScreen extends StatelessWidget {
  const BookingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingReviewController>();

    // Fallback if args aren't passed - controller handles dummy init
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.reviewText, backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),

              // Big Image
              ClipRRect(
                borderRadius: BorderRadius.circular(40.w),
                child: controller.booking.coverImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: controller.booking.coverImage,
                        width: 200.w,
                        height: 200.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 200.w,
                          height: 200.w,
                          color: const Color(0xFFE5E7EB),
                          child: Icon(
                            Icons.image_outlined,
                            size: 48.w,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 200.w,
                          height: 200.w,
                          color: const Color(0xFFE5E7EB),
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48.w,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      )
                    : Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(40.w),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          size: 48.w,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
              ),

              SizedBox(height: 24.h),

              // Title
              Text(
                controller.booking.title,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),

              SizedBox(height: 8.h),

              // Category
              Text(
                controller.booking.category,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),

              SizedBox(height: 24.h),

              // Star Rating Row
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => controller.updateRating(index + 1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Icon(
                          index < controller.rating.value
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFBBF24),
                          size: 44.w,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 24.h),
              const Divider(color: Color(0xFFF3F4F6), height: 1),
              SizedBox(height: 24.h),

              // Review Text Field Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: TextField(
                  controller: controller.reviewController,
                  maxLines: 4,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                    height: 1.5,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: Row(
          children: [
            // Cancel Button
            Expanded(
              child: Material(
                color: const Color(0xFFEAEBFE),
                borderRadius: BorderRadius.circular(32.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(32.w),
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.w),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancelText,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Submit Button
            Expanded(
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(32.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(32.w),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  onTap: controller.submitReview,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.w),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.submitText,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 16.sp,
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
      ),
    );
  }
}
