import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/user_home_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/screens/all_featured_activities_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/screens/all_featured_courses_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/activity_grid.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/featured_activity_list.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/featured_course_list.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/featured_activities_section_header.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/featured_courses_section_header.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/user_home_app_bar.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserHomeController>();  

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

                  // AppBar
                  UserHomeAppBar(controller: controller),
                  SizedBox(height: 24.h),

                  // Explore Activities
                  FeaturedCoursesSectionHeader(
                    title: AppLocalizations.of(context)!.exploreActivities,
                    showSeeAll: false,
                  ),
                  SizedBox(height: 16.h),
                  const ActivityGrid(),
                  SizedBox(height: 32.h),

                  // Featured Courses
                  FeaturedCoursesSectionHeader(
                    title: AppLocalizations.of(context)!.featuredCourses,
                    onSeeAllTap: () {
                      Get.to(() => const AllFeaturedCoursesScreen());
                    },
                  ),
                  SizedBox(height: 16.h),
                  const FeaturedCourseList(),
                  SizedBox(height: 32.h),

                  // Featured Activities
                  FeaturedActivitiesSectionHeader(
                    title: AppLocalizations.of(context)!.featuredActivities,
                    onSeeAllTap: () {
                      Get.to(() => const AllFeaturedActivitiesScreen());
                    },
                  ),
                  SizedBox(height: 16.h),
                  const FeaturedActivityList(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
        ),
    );
  }
}
