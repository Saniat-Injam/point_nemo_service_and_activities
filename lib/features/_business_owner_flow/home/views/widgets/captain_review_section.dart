import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/captain_details_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class CaptainReviewSection extends StatelessWidget {
  const CaptainReviewSection({super.key});

  String _formatTimeAgo(BuildContext context, String iso) {
    if (iso.isEmpty) return AppLocalizations.of(context)!.justNow;
    try {
      final dt = DateTime.parse(iso).toLocal();
      final difference = DateTime.now().difference(dt);
      if (difference.inDays > 365) {
        return AppLocalizations.of(context)!.yearsAgo((difference.inDays / 365).floor().toString());
      }
      if (difference.inDays > 30) {
        return AppLocalizations.of(context)!.monthsAgo((difference.inDays / 30).floor().toString());
      }
      if (difference.inDays > 0) return AppLocalizations.of(context)!.daysAgo(difference.inDays.toString());
      if (difference.inHours > 0) return AppLocalizations.of(context)!.hoursAgo(difference.inHours.toString());
      if (difference.inMinutes > 0) return AppLocalizations.of(context)!.minsAgo(difference.inMinutes.toString());
      return AppLocalizations.of(context)!.justNow;
    } catch (_) {
      return iso; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaptainDetailsController>();

    return Obx(() {
      if (controller.isLoadingReviews.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final reviews = controller.reviews;
      if (reviews.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.reviewsText,
              style: getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D1B20),
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.rate_review_outlined,
                      color: const Color(0xFF9CA3AF),
                      size: 36.w,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.noReviewsYet,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(context)!.noCaptainReviews,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.reviewsText,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.seeAll,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          ...reviews.map((r) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildReviewCard(
              name: r.user?.fullName ?? 'Unknown',
              imagePath: r.user?.profileImage ?? '',
              rating: r.rating,
              review: r.comment,
              likes: r.likes.toString(),
              timeAgo: _formatTimeAgo(context, r.createdAt),
            ),
          )),
        ],
      );
    });
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 48.w,
      height: 48.w,
      color: const Color(0xFFE5E7EB),
      child: Icon(Icons.person, color: const Color(0xFF9CA3AF), size: 24.w),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String imagePath,
    required int rating,
    required String review,
    required String likes,
    required String timeAgo,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24.w),
                child: imagePath.isNotEmpty && imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        width: 48.w,
                        height: 48.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackImage(),
                      )
                    : _buildFallbackImage(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  name,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFF59E0B),
                size: 16.w,
              );
            }),
          ),
          SizedBox(height: 12.h),
          Text(
            review,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4B5563),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                color: const Color(0xFFEF4444),
                size: 18.w,
              ),
              SizedBox(width: 6.w),
              Text(
                likes,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(width: 24.w),
              Text(
                timeAgo,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


