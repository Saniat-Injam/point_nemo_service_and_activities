import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/business_owner_home_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/business_owner_dashboard_model.dart';
import 'package:point_nemo_service_and_activities/features/.common/verification/verification_pending_widget.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/widgets/dashboard_shimmer_loading.dart';

import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/icon_path.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/widgets/performance_overview_chart_painter.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/default_profile_avatar.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BusinessOwnerHomeScreen extends StatelessWidget {
  const BusinessOwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessOwnerHomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, controller),
              Obx(() {
                if (controller.isVerificationPending.value) {
                  return VerificationPendingWidget(
                    submissionDate: controller.submissionDate.value,
                    onSupportPressed: controller.onSupportPressed,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.w),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              ImagePath.navalCaptain,
                              height: 100.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.hireCaptains,
                                  style: getTextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppLocalizations.of(context)!.professionalExperienced,
                                  style: getTextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 18.h),
                                CustomSubmitButton(
                                  color: AppColors.primary,
                                  text: "",
                                  onTap: () =>
                                      Get.toNamed(AppRoute.hireCaptainsScreen),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 8.h,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.hireText,
                                        style: getTextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.textWhite,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14.sp,
                                        color: AppColors.textWhite,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: 24.h),
                    // _buildFilterSection(controller),
                    SizedBox(height: 24.h),
                    if (controller.isLoading.value) ...[
                      const DashboardShimmerLoading(),
                    ] else ...[
                      _buildStatsRow(context, controller),
                      SizedBox(height: 24.h),
                      _buildRecentActivity(context, controller),
                      SizedBox(height: 24.h),
                      _buildPerformanceOverview(context, controller),
                    ],
                  ],
                );
              }),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BusinessOwnerHomeController controller) {
    return Row(
      children: [
        Obx(() {
          final localImage = controller.userLocalImage;
          final networkUrl = controller.userImage;
          return ClipOval(
            child: SizedBox(
              width: 50.w,
              height: 50.w,
              child: localImage.isNotEmpty
                  ? Image.file(File(localImage), fit: BoxFit.cover)
                  : networkUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: networkUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => DefaultProfileAvatar(iconSize: 30.w),
                    )
                  : DefaultProfileAvatar(iconSize: 30.w),
            ),
          );
        }),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.userName,
                  style: getTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF040A18),
                  ),
                ),
              ),
              Obx(
                () => Text(
                  controller.userRole.value,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7ED),
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Text(
            AppLocalizations.of(context)!.activeText,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF22C55E),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoute.notificationsScreen),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(IconPath.notification),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildFilterSection(BusinessOwnerHomeController controller) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: controller.filters.map((filter) {
  //         return Obx(() {
  //           final isSelected = controller.selectedFilter.value == filter;
  //           return GestureDetector(
  //             onTap: () => controller.changeFilter(filter),
  //             child: Container(
  //               margin: EdgeInsets.only(right: 12.w),
  //               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
  //               decoration: BoxDecoration(
  //                 color: isSelected ? const Color(0xFF0D1B3E) : Colors.white,
  //                 borderRadius: BorderRadius.circular(24.w),
  //                 border: Border.all(
  //                   color: isSelected
  //                       ? Colors.transparent
  //                       : const Color(0xFFE5E7EB),
  //                 ),
  //               ),
  //               child: Text(
  //                 filter,
  //                 style: getTextStyle(
  //                   fontSize: 16.sp,
  //                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
  //                   color: isSelected ? Colors.white : const Color(0xFF6B7280),
  //                 ),
  //               ),
  //             ),
  //           );
  //         });
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildStatsRow(BuildContext context, BusinessOwnerHomeController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: AppLocalizations.of(context)!.totalEarnings,
            value: controller.totalEarnings.value,
            fullValue: '\$${controller.rawTotalEarnings.value}',
            icon: Icons.attach_money,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            label: AppLocalizations.of(context)!.confirmedText,
            value: controller.confirmedCount.value.toString(),
            icon: Icons.calendar_today_outlined,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            label: AppLocalizations.of(context)!.pending,
            value: controller.pendingCount.value.toString(),
            icon: Icons.access_time,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    String? fullValue,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22.sp, color: const Color(0xFF040A18)),
          SizedBox(height: 24.h),
          Tooltip(
            message: fullValue ?? value,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 3),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF040A18),
              borderRadius: BorderRadius.circular(8.r),
            ),
            textStyle: getTextStyle(
              fontSize: 14.sp,
              color: Colors.white,
            ),
            preferBelow: false,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getTextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF040A18),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, BusinessOwnerHomeController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.recentActivity,
                style: getTextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(
            () => Column(
              children: controller.recentActivities.map((activity) {
                return _buildActivityItem(activity);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(DashboardActivity activity) {
    Color statusColor;
    Color statusBgColor;

    final statusUpper = activity.status.toUpperCase();
    String displayStatus = activity.status;
    if (activity.status.isNotEmpty) {
      displayStatus = activity.status[0].toUpperCase() + activity.status.substring(1).toLowerCase();
    }

    switch (statusUpper) {
      case 'PENDING':
        statusColor = const Color(0xFFA65F00);
        statusBgColor = const Color(0xFFFFF7E6);
        break;
      case 'CONFIRMED':
        statusColor = const Color(0xFF2972FF);
        statusBgColor = const Color(0xFFEBF2FF);
        break;
      case 'COMPLETED':
        statusColor = const Color(0xFF22C55E);
        statusBgColor = const Color(0xFFE6F7ED);
        break;
      case 'REJECTED':
      case 'CANCELLED':
        statusColor = const Color(0xFFEF4444);
        statusBgColor = const Color(0xFFFEE2E2);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.shade100;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  activity.serviceName,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Text(
              displayStatus,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceOverview(BuildContext context, BusinessOwnerHomeController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.performanceOverview,
            style: getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context)!.thisWeekVsLastWeek,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 150.h,
            width: double.infinity,
            child: Obx(() => CustomPaint(
              painter: PerformanceOverviewChartPainter(
                points: controller.thisWeekPerformance,
                pointsDashed: controller.lastWeekPerformance,
              ),
            )),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppLocalizations.of(context)!.mon,
              AppLocalizations.of(context)!.tue,
              AppLocalizations.of(context)!.wed,
              AppLocalizations.of(context)!.thu,
              AppLocalizations.of(context)!.fri,
              AppLocalizations.of(context)!.sat,
              AppLocalizations.of(context)!.sun
            ].map((
              day,
            ) {
              return Text(
                day,
                style: getTextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9CA3AF),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
