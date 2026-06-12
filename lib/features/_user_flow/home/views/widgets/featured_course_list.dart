import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_details_screen.dart';

class FeaturedCourseList extends StatelessWidget {
  const FeaturedCourseList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeaturedCoursesController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 250,
          child: Center(child: CustomLoadingIndicator()),
        );
      }

      if (controller.featuredCourses.isEmpty) {
        return SizedBox(
          height: 250,
          child: Center(
            child: Text(
              'No courses available',
              style: getTextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      }

      return SizedBox(
        height: 250.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemCount: controller.featuredCourses.length,
          itemBuilder: (context, index) {
            final course = controller.featuredCourses[index];
            // Find the matching index in allCourses for toggleFavorite
            final allIdx = controller.allCourses.indexWhere((e) => e.id == course.id);
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => const ServiceDetailsScreen(),
                  arguments: course.id,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: _buildCourseCard(
                  context,
                  course,
                  allIdx >= 0 ? allIdx : index,
                  controller,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildCourseCard(
    BuildContext context,
    ServiceModel course,
    int allIndex,
    FeaturedCoursesController controller,
  ) {
    return Container(
      width: 280.w,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0D2137),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                topRight: Radius.circular(16.w),
              ),
              image: course.coverImage.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(course.coverImage),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF040A18).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Text(
                          'Certified Course',
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.toggleFavorite(allIndex, course.id),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              course.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: course.isFavorite
                                  ? const Color(0xFF040A18)
                                  : const Color(0xFF1D1B20),
                              size: 18.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Details section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${course.totalRating} reviews | ${course.address}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${course.price.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF040A18),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Text(
                          'View Details',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
