import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/user_home_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/screens/user_favorite_screen.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/default_profile_avatar.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class UserHomeAppBar extends StatelessWidget {
  final UserHomeController controller;

  const UserHomeAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Obx(() {
            final localImage = controller.userLocalImage;
            final networkUrl = controller.userImage;
            return ClipOval(
              child: SizedBox(
                width: 48.w,
                height: 48.w,
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
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          _buildTopIcon(
            Icons.favorite_border,
            onTap: () {
              if (controller.isGuest) {
                controller.showGuestDialog();
              } else {
                Get.to(() => const UserFavoriteScreen());
              }
            },
          ),
          SizedBox(width: 12.w),
          _buildTopIcon(
            Icons.notifications_none,
            onTap: () {
              if (controller.isGuest) {
                controller.showGuestDialog();
              } else {
                Get.toNamed(AppRoute.notificationsScreen);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Icon(icon, color: const Color(0xFF1D1B20), size: 24.w),
      ),
    );
  }
}
