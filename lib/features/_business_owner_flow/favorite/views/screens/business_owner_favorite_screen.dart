import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/models/captain_model.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/screens/captain_details_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/favorite/controllers/business_owner_favorite_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BusinessOwnerFavoriteScreen extends StatelessWidget {
  const BusinessOwnerFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusinessOwnerFavoriteController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.favoriteText,
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
                  color: Color(0xFFE5E7EB),
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

        if (controller.favoriteCaptains.isEmpty) {
          return Center(
            child: Text(
              'No favorites yet.',
              style: getTextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: controller.favoriteCaptains.length,
                itemBuilder: (context, index) {
                  final captain = controller.favoriteCaptains[index];
                  return _buildCaptainCard(context, captain, controller);
                },
              ),
            ),
            if (controller.isLoadingMore.value)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const CustomLoadingIndicator(),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCaptainCard(
    BuildContext context,
    CaptainModel captain,
    BusinessOwnerFavoriteController controller,
  ) {
    final bool hasImage =
        captain.profileImage != null && captain.profileImage!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
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
                child: GestureDetector(
                  onTap: () {
                    controller.removeFavorite(captain.id);
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: const Color(0xFF040A18),
                      size: 24.sp,
                    ),
                  ),
                ),
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
                          captain.id == '1' ? '5 (120)' : '4.9 (100)',
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
                          'per hour',
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
