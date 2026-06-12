import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_details_screen.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class AllFeaturedCoursesScreen extends StatelessWidget {
  const AllFeaturedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeaturedCoursesController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.featuredCourses,
          style: getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Center(
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(20.w),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF1D1B20),
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 70.w,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoadingIndicator());
        }

        if (controller.allCourses.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noCoursesAvailable,
              style: getTextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          );
        }

        return ListView.separated(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          itemCount: controller.allCourses.length +
              (controller.hasMore.value ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            if (index >= controller.allCourses.length) {
              return Obx(
                () => controller.isLoadingMore.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CustomLoadingIndicator()),
                      )
                    : const SizedBox.shrink(),
              );
            }
            return _buildCourseItem(context, controller, index, controller.allCourses[index]);
          },
        );
      }),
    );
  }

  Widget _buildCourseItem(
    BuildContext context,
    FeaturedCoursesController controller,
    int index,
    ServiceModel course,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ServiceDetailsScreen(),
          arguments: course.id,
        );
      },
      child: Container(
        width: double.infinity,
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
            // Cover image
            Container(
              height: 160.h,
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
                            AppLocalizations.of(context)!.certifiedCourse,
                            style: getTextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleFavorite(index, course.id),
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
            // Details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${course.totalRating} ${AppLocalizations.of(context)!.reviews} | ${course.address}',
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
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF040A18),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.viewDetailsText,
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
          ],
        ),
      ),
    );
  }
}
