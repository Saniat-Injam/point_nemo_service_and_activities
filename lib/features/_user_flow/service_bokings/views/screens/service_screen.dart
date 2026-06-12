import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/service_details_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/models/service_model.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/views/widgets/search_and_filter_header.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/views/widgets/boat_filter_drawer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/views/widgets/dummy_filter_drawer.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    return Scaffold(
      endDrawer: Obx(() {
        if (controller.categoryTitle.value == 'Rent Boat') {
          return const BoatFilterDrawer();
        }
        return const DummyFilterDrawer();
      }),
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1D1B20),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 60.w,
        title: Obx(
          () => Text(
            _getLocalizedCategoryTitle(context, controller.categoryTitle.value),
            style: getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D1B20),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchAndFilterHeader(
            controller: controller.searchAndFilterController,
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h, bottom: 16.h),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const CustomLoadingIndicator();
              }
              if (controller.servicesList.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noServicesFoundDot,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    controller.fetchMoreServices();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h).copyWith(bottom: 16.h),
                  itemCount: controller.servicesList.length +
                      (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.servicesList.length) {
                      // Bottom loader for pagination
                      return Obx(
                        () => controller.isLoadingMore.value
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const Center(child: CustomLoadingIndicator()),
                              )
                            : const SizedBox.shrink(),
                      );
                    }
                    final service = controller.servicesList[index];
                    return _ServiceCard(service: service);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  String _getLocalizedCategoryTitle(BuildContext context, String value) {
    final t = AppLocalizations.of(context)!;
    if (value == 'Rent Boat') return t.rentBoatsText;
    if (value == 'Water Sports') return t.waterSportsText2;
    if (value == 'Dive & Snorkel') return t.divingCoursesText;
    if (value == 'Fishing Trip') return t.fishingTripsText;
    return value;
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ServiceDetailsScreen(),
          arguments: service.id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
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
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.w),
                  ),
                  child: service.coverImage.isNotEmpty
                      ? Image.network(
                          service.coverImage,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _ImagePlaceholder(
                            height: 200.h,
                            serviceType: service.type,
                          ),
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _ImageLoadingShimmer(height: 200.h);
                          },
                        )
                      : _ImagePlaceholder(
                          height: 200.h,
                          serviceType: service.type,
                        ),
                ),
                // Verified badge
                if (service.isVerifiedByAdmin)
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: Colors.white, size: 12.w),
                          SizedBox(width: 4.w),
                          Text(
                            AppLocalizations.of(context)!.verifiedText,
                            style: getTextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: () {
                      final controller = Get.find<ServiceController>();
                      controller.toggleFavorite(service.id);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        service.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: service.isFavorite ? const Color(0xFF040A18) : const Color(0xFF1D1B20),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: getTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D1B20),
                          ),
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
                            service.averageRating > 0
                                ? '${service.averageRating.toStringAsFixed(1)} (${service.totalRating})'
                                : 'New',
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Location
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
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Divider(color: const Color(0xFFE5E7EB), height: 1.h),
                  SizedBox(height: 16.h),
                  // Price and View Details Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${service.price.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const ServiceDetailsScreen(),
                            arguments: service.id,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF040A18),
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.viewDetails,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
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

class _ImagePlaceholder extends StatelessWidget {
  final double height;
  final String serviceType;
  const _ImagePlaceholder({required this.height, required this.serviceType});

  IconData get _icon {
    switch (serviceType) {
      case 'BOAT_RENTAL':
        return Icons.directions_boat;
      case 'WATER_SPORTS':
        return Icons.surfing;
      case 'DIVING_COURSE':
        return Icons.scuba_diving;
      case 'FISHING_TRIP':
        return Icons.set_meal;
      default:
        return Icons.water;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2849), Color(0xFF1A4B8C)],
        ),
      ),
      child: Icon(_icon, color: Colors.white24, size: 64),
    );
  }
}

class _ImageLoadingShimmer extends StatelessWidget {
  final double height;
  const _ImageLoadingShimmer({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFFE5E7EB),
      child: const Center(
        child: CustomLoadingIndicator(),
      ),
    );
  }
}
