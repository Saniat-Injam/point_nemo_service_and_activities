import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/icon_path.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/logout_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/widgets/profile_action_dialog.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/default_profile_avatar.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logoutController = Get.find<LogoutController>();
    final profileController = Get.find<CommonProfileController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(profileController),
              SizedBox(height: 30.h),
              Text(
                AppLocalizations.of(context)!.general,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              _buildListTile(
                icon: Icons.person_outline,
                title: AppLocalizations.of(context)!.editProfile,
                onTap: () {
                  Get.toNamed(AppRoute.editProfileScreen);
                },
              ),
              SizedBox(height: 16.h),
              _buildListTile(
                icon: Icons.lock_outline,
                title: AppLocalizations.of(context)!.changePassword,
                onTap: () {
                  Get.toNamed(AppRoute.changePasswordScreen);
                },
              ),
              SizedBox(height: 16.h),
              _buildListTile(
                iconWidget: SvgPicture.asset(
                  IconPath.world,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.contain,
                ),
                title: AppLocalizations.of(context)!.language,
                onTap: () {
                  Get.toNamed(AppRoute.languageScreen);
                },
              ),
              if (StorageService.role == 'BUSINESS_OWNER') ...[
                SizedBox(height: 16.h),
                _buildListTile(
                  icon: Icons.favorite_border,
                  title: AppLocalizations.of(context)!.favorite,
                  onTap: () {
                    Get.toNamed(AppRoute.businessOwnerFavoriteScreen);
                  },
                ),
                SizedBox(height: 16.h),
                _buildListTile(
                  icon: Icons.post_add_outlined,
                  title: AppLocalizations.of(context)!.registerYourBoat,
                  onTap: () {
                    Get.toNamed(AppRoute.registerBoatScreen);
                  },
                ),
              ],
              SizedBox(height: 30.h),
              Text(
                AppLocalizations.of(context)!.preferences,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              _buildListTile(
                iconWidget: Icon(
                  Icons.live_help_outlined,
                  color: AppColors.textPrimary,
                  size: 24.w,
                ),
                title: AppLocalizations.of(context)!.helpSupport,
                onTap: () {
                  Get.toNamed(AppRoute.helpSupportScreen);
                },
              ),
              SizedBox(height: 16.h),
              Obx(
                () => _buildListTile(
                  iconWidget: profileController.isDeleteLoading.value
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : Icon(Icons.delete, color: Colors.red, size: 24.w),
                  title: "Delete account",
                  textColor: AppColors.textPrimary,
                  onTap: profileController.isDeleteLoading.value
                      ? () {}
                      : () {
                          Get.dialog(
                            ProfileActionDialog(
                              title:
                                  "Are you sure want to Delete your account?",

                              actionText: "Delete",
                              onCancel: () => Get.back(),
                              onAction: () {
                                Get.back();
                                profileController.deleteAccount();
                                // logoutController.logout();
                              },
                            ),
                          );
                        },
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => _buildListTile(
                  iconWidget: logoutController.isLoading.value
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : Icon(Icons.logout, color: Colors.red, size: 24.w),
                  title: AppLocalizations.of(context)!.logout,
                  textColor: AppColors.textPrimary,
                  onTap: logoutController.isLoading.value
                      ? () {}
                      : () {
                          Get.dialog(
                            ProfileActionDialog(
                              title: AppLocalizations.of(
                                context,
                              )!.logoutConfirmation,
                              actionText: AppLocalizations.of(
                                context,
                              )!.logOutAction,
                              onCancel: () => Get.back(),
                              onAction: () {
                                Get.back();
                                logoutController.logout();
                              },
                            ),
                          );
                        },
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(CommonProfileController controller) {
    return Obx(() {
      if (controller.isLoadingProfile.value) {
        return const CustomLoadingIndicator();
      }
      final imageUrl = controller.userProfileImage.value;
      final localImageUrl = controller.savedProfileImagePath.value;
      return Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 70.w,
              height: 70.w,
              child: localImageUrl.isNotEmpty
                  ? Image.file(File(localImageUrl), fit: BoxFit.cover)
                  : imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) =>
                          DefaultProfileAvatar(iconSize: 40.w),
                    )
                  : DefaultProfileAvatar(iconSize: 40.w),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.userName.value.isNotEmpty
                    ? controller.userName.value
                    : '—',
                style: getTextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                controller.userEmail.value.isNotEmpty
                    ? controller.userEmail.value
                    : '—',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildListTile({
    IconData? icon,
    Widget? iconWidget,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(color: AppColors.textFormFieldBorder),
        ),
        child: Row(
          children: [
            if (iconWidget != null)
              iconWidget
            else if (icon != null)
              Icon(icon, color: AppColors.textPrimary, size: 24.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF9CA3AF),
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}
