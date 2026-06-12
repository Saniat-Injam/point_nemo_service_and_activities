import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/hire_captains_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/captain_model.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/screens/captain_details_screen.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class HireCaptainsScreen extends StatelessWidget {
  const HireCaptainsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HireCaptainsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.hireCaptains,
        titleColor: AppColors.textPrimary,
        backgroundColor: Colors.white,
        showBackIcon: true,
        action: IconButton(
          icon: Icon(Icons.search, color: AppColors.textPrimary, size: 28.w),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          // ── Gender Toggle ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(24.w),
              ),
              child: Row(
                children: [
                  _GenderTab(
                    label: AppLocalizations.of(context)!.maleText,
                    value: 'MALE',
                    controller: controller,
                  ),
                  _GenderTab(
                    label: AppLocalizations.of(context)!.femaleText,
                    value: 'FEMALE',
                    controller: controller,
                  ),
                  _GenderTab(
                    label: AppLocalizations.of(context)!.otherText,
                    value: 'OTHER',
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // ── Captain List ───────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const CustomLoadingIndicator();
              }
              if (controller.captains.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noCaptainsFound,
                    style: getTextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchCaptains,
                color: AppColors.textPrimary,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  itemCount: controller.captains.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.captains.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomLoadingIndicator(),
                      );
                    }
                    return _buildCaptainCard(context, controller.captains[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainCard(BuildContext context, CaptainModel captain) {
    final bool hasImage =
        captain.profileImage != null && captain.profileImage!.isNotEmpty;
    final controller = Get.find<HireCaptainsController>();

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Image and Heart Icon ─────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.w),
                child: hasImage
                    ? Image.network(
                        captain.profileImage!,
                        height: 240.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (_, __, ___) =>
                            _buildAvatarPlaceholder(captain.fullName, 240.h),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            height: 240.h,
                            child: const CustomLoadingIndicator(),
                          );
                        },
                      )
                    : _buildAvatarPlaceholder(captain.fullName, 240.h),
              ),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Obx(() {
                  final isFavorited =
                      controller.favoritedIds.contains(captain.id);
                  return GestureDetector(
                    onTap: () => controller.toggleFavorite(captain.id),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited
                            ? AppColors.textPrimary
                            : AppColors.textPrimary,
                        size: 24.sp,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          // ── Details ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Rating Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        captain.fullName,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
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
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          captain.captainRate != null
                              ? captain.captainRate!.toStringAsFixed(0)
                              : 'N/A',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Address Row
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF6B7280),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        captain.address.isNotEmpty
                            ? captain.address
                            : AppLocalizations.of(context)!.addressNotProvided,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Divider(
                  color: const Color(0xFFE5E7EB),
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(height: 16.h),
                // Rate & Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.perDay,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          captain.captainRate != null
                              ? '\$${captain.captainRate!.toStringAsFixed(2)}'
                              : AppLocalizations.of(context)!.negotiable,
                          style: getTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    // View Details Button
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CaptainDetailsScreen(
                            captain: captain,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF040A18),
                          borderRadius: BorderRadius.circular(30.w),
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
    );
  }

  Widget _buildAvatarPlaceholder(String name, double height) {
    final initials =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Center(
        child: Text(
          initials,
          style: getTextStyle(
            fontSize: 64.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// ── Gender Tab ──────────────────────────────────────────────────────────────

class _GenderTab extends StatelessWidget {
  final String label;
  final String value;
  final HireCaptainsController controller;

  const _GenderTab({
    required this.label,
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedGender.value == value;
        return GestureDetector(
          onTap: () => controller.changeGender(value),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF040A18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24.w),
            ),
            child: Text(
              label,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      }),
    );
  }
}
