import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';

import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_screen.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ActivityGrid extends StatelessWidget {
  const ActivityGrid({super.key});

  void _navigateToEvents(String category) {
    Get.to(
      () => const ServiceScreen(),
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.8,
        children: [
          GestureDetector(
            onTap: () => _navigateToEvents('Rent Boat'),
            child: _buildActivityCard(
              title: AppLocalizations.of(context)!.rentBoatsText,
              subtitle: AppLocalizations.of(context)!.rentBoatsSubtitle,
              imagePath: ImagePath.rentBoats,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToEvents('Water Sports'),
            child: _buildActivityCard(
              title: AppLocalizations.of(context)!.waterSportsText2,
              subtitle: AppLocalizations.of(context)!.waterSportsSubtitle,
              imagePath: ImagePath.waterSports,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToEvents('Dive & Snorkel'),
            child: _buildActivityCard(
              title: AppLocalizations.of(context)!.divingCoursesText,
              subtitle: AppLocalizations.of(context)!.divingCoursesSubtitle,
              imagePath: ImagePath.divingCourses,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToEvents('Fishing Trip'),
            child: _buildActivityCard(
              title: AppLocalizations.of(context)!.fishingTripsText,
              subtitle: AppLocalizations.of(context)!.fishingTripsSubtitle,
              imagePath: ImagePath.fishingTrips,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
