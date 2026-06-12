import 'package:flutter/material.dart';

import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/controllers/user_explore_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_details_screen.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/views/widgets/search_and_filter_header.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/views/widgets/boat_filter_drawer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/views/widgets/dummy_filter_drawer.dart';

class UserExploreScreen extends StatelessWidget {
  const UserExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserExploreController>();
    return Scaffold(
      endDrawer: Obx(() {
        if (controller.selectedCategory.value == 'Boat Rental') {
          return const BoatFilterDrawer();
        }
        return const DummyFilterDrawer();
      }),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SearchAndFilterHeader(controller: controller.searchAndFilterController),
            SizedBox(height: 16.h),
            _buildCategories(context, controller),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const CustomLoadingIndicator();
                }

                if (controller.services.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noServicesFound,
                      style: getTextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ).copyWith(bottom: 100.h),
                  itemCount: controller.services.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.services.length) {
                      return Obx(() {
                        if (controller.isLoadingMore.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const CustomLoadingIndicator(),
                          );
                        }
                        return const SizedBox.shrink();
                      });
                    }
                    final service = controller.services[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: _buildExploreItem(context, service, controller),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategories(BuildContext context, UserExploreController controller) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, index) {
          final label = controller.categories[index];
          final emoji = controller.emojiFor(label);
          return Obx(() {
            final isSelected = controller.selectedCategory.value == label;
            return GestureDetector(
              onTap: () => controller.changeCategory(label),
              child: _buildCategoryChip(
                label: _getLocalizedCategory(context, label),
                iconUrl: emoji.isEmpty ? null : emoji,
                isSelected: isSelected,
              ),
            );
          });
        },
      ),
    );
  }

  String _getLocalizedCategory(BuildContext context, String category) {
    switch (category) {
      case 'All':
        return AppLocalizations.of(context)!.allText;
      case 'Boat Rental':
        return AppLocalizations.of(context)!.boatRentalText;
      case 'Water Sports':
        return AppLocalizations.of(context)!.waterSportsText;
      case 'Diving Course':
        return AppLocalizations.of(context)!.divingCourseText;
      case 'Fishing Trip':
        return AppLocalizations.of(context)!.fishingTripText;
      default:
        return category;
    }
  }

  Widget _buildCategoryChip({
    required String label,
    String? iconUrl,
    bool isSelected = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF040A18) : Colors.white,
        borderRadius: BorderRadius.circular(24.h),
        border: Border.all(color: const Color(0xFF040A18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconUrl != null) ...[
            Text(iconUrl, style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF040A18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreItem(
    BuildContext context,
    ServiceModel service,
    UserExploreController controller,
  ) {
    final fallback = controller.getFallbackImage(service.type);
    final rating = service.averageRating;
    final totalRating = service.totalRating;

    return GestureDetector(
      onTap: () => Get.to(
        () => const ServiceDetailsScreen(),
        arguments: service.id,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.w),
                  ),
                  child: service.coverImage.isNotEmpty
                      ? Image.network(
                          service.coverImage,
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            fallback,
                            height: 200.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          fallback,
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF040A18),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.instantBooking,
                      style: getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    height: 36.w,
                    width: 36.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: const Color(0xFF1D1B20),
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: getTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D1B20),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFF59E0B),
                            size: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${rating.toStringAsFixed(1)} ($totalRating)',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: const Color(0xFF6B7280),
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          service.address,
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: const Color(0xFF6B7280),
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${service.dailyStartTime} – ${service.dailyEndTime}',
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: const Color(0xFFF3F4F6), height: 1),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.fromText,
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            '\$${service.price.toStringAsFixed(0)}',
                            style: getTextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1D1B20),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(
                          () => const ServiceDetailsScreen(),
                          arguments: service.id,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF040A18),
                            borderRadius: BorderRadius.circular(24.w),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.viewDetails,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
