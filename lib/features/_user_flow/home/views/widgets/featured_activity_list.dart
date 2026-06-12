import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_activities_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_details_screen.dart';

class FeaturedActivityList extends StatelessWidget {
  const FeaturedActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeaturedActivitiesController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox(
            height: 200,
            child: Center(child: CustomLoadingIndicator()),
          );
        }

        if (controller.featuredActivities.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No activities available',
                style: getTextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            for (int i = 0; i < controller.featuredActivities.length; i++) ...[
              if (i > 0) SizedBox(height: 16.h),
              Builder(builder: (context) {
                final activity = controller.featuredActivities[i];
                final allIdx = controller.allActivities.indexWhere((e) => e.id == activity.id);
                return _buildActivityItem(
                  context,
                  activity,
                  allIdx >= 0 ? allIdx : i,
                  controller,
                );
              }),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    ServiceModel activity,
    int allIndex,
    FeaturedActivitiesController controller,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ServiceDetailsScreen(),
          arguments: activity.id,
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover image / placeholder
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: const Color(0xFF0D2137),
                borderRadius: BorderRadius.circular(12.w),
                image: activity.coverImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(activity.coverImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: activity.coverImage.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.waves_rounded,
                        color: Colors.white54,
                        size: 32.w,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.w,
                        color: const Color(0xFF6B7280),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          activity.address.isNotEmpty
                              ? activity.address
                              : activity.type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14.w,
                        color: const Color(0xFFF59E0B),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        activity.averageRating.toStringAsFixed(1),
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      Text(
                        '  (${activity.totalRating})',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${activity.price.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.toggleFavorite(allIndex, activity.id),
                        child: Icon(
                          activity.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20.w,
                          color: activity.isFavorite
                              ? const Color(0xFF040A18)
                              : const Color(0xFF1D1B20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
