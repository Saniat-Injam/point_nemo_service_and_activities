import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_intl_phone_field.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_dropdown.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_date_picker.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/default_profile_avatar.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve shared CommonProfileController — never use Get.put() in screens
    final CommonProfileController controller =
        Get.find<CommonProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.editProfile,
        borderRadius: 0,
        backgroundColor: Colors.white,
      ),
      // Show a full-screen loader while getMe is still in flight,
      // then show the form pre-populated with the fetched data.
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const CustomLoadingIndicator();
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile Avatar ──────────────────────────────────────────
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        final localPath = controller.profileImagePath.value;
                        final networkUrl = controller.userProfileImage.value;
                        return ClipOval(
                          child: SizedBox(
                            width: 110.w,
                            height: 110.w,
                            child: localPath.isNotEmpty
                                ? Image.file(File(localPath), fit: BoxFit.cover)
                                : networkUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: networkUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) =>
                                        Container(color: Colors.grey.shade200),
                                    errorWidget: (_, __, ___) =>
                                        DefaultProfileAvatar(iconSize: 60.w),
                                  )
                                : DefaultProfileAvatar(iconSize: 60.w),
                          ),
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickProfileImage,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF040A18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.w,
                              ),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // ── Full Name (editable) ────────────────────────────────────
                _buildLabel(AppLocalizations.of(context)!.fullName),
                CustomTextFormField(
                  controller: controller.nameController,
                  hintText: AppLocalizations.of(context)!.enterFullName,
                  containerColor: Colors.white,
                  borderRedius: 12.w,
                ),
                SizedBox(height: 16.h),

                // ── Email (read-only — fetched from getMe) ──────────────────
                _buildLabel(AppLocalizations.of(context)!.emailAddress),
                CustomTextFormField(
                  controller: controller.emailController,
                  hintText: AppLocalizations.of(context)!.emailAddress,
                  containerColor: const Color(0xFFF3F4F6),
                  borderRedius: 12.w,
                  readonly: true,
                  suffixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                    size: 20.w,
                  ),
                ),
                SizedBox(height: 16.h),

                // ── Phone Number (read-only — fetched from getMe) ───────────
                _buildLabel(AppLocalizations.of(context)!.phoneNumber),
                Builder(
                  builder: (_) {
                    final phone =
                        controller.userProfile.value?.phoneNumber ?? '';
                    final bool isPhoneEmpty = phone.trim().isEmpty;

                    return IgnorePointer(
                      ignoring: !isPhoneEmpty,
                      child: CustomIntlPhoneField(
                        initialValue: controller.phoneController.text.isNotEmpty
                            ? (controller.phoneController.text.startsWith('+')
                                  ? controller.phoneController.text
                                  : '+${controller.phoneController.text}')
                            : null,
                        readOnly: !isPhoneEmpty,
                        showCursor: isPhoneEmpty,
                        onChanged: (phoneOption) {
                          controller.phoneController.text =
                              phoneOption.completeNumber;
                        },
                        hintText: AppLocalizations.of(context)!.phoneNumber,
                        fillColor: isPhoneEmpty
                            ? Colors.white
                            : const Color(0xFFF3F4F6),
                        counterText: '',
                        suffixIcon: isPhoneEmpty
                            ? null
                            : Icon(
                                Icons.lock_outline,
                                color: AppColors.textSecondary,
                                size: 20.w,
                              ),
                        borderRadius: 12.w,
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),

                // ── Date of Birth (editable) ────────────────────────────────
                _buildLabel(AppLocalizations.of(context)!.dateOfBirth),
                CustomTextFormField(
                  controller: controller.dobController,
                  hintText: AppLocalizations.of(context)!.enterDateOfBirth,
                  containerColor: Colors.white,
                  borderRedius: 12.w,
                  readonly: true,
                  onClick: () async {
                    DateTime initialDate = DateTime.now();
                    if (controller.dobController.text.isNotEmpty) {
                      try {
                        final parts = controller.dobController.text.split(' ');
                        if (parts.length == 3) {
                          final day = int.parse(parts[1].replaceAll(',', ''));
                          final year = int.parse(parts[2]);
                          final monthNames = [
                            "January",
                            "February",
                            "March",
                            "April",
                            "May",
                            "June",
                            "July",
                            "August",
                            "September",
                            "October",
                            "November",
                            "December",
                          ];
                          final month = monthNames.indexOf(parts[0]) + 1;
                          if (month > 0) {
                            initialDate = DateTime(year, month, day);
                          }
                        }
                      } catch (e) {
                        // Default to current date if parse fails
                      }
                    }

                    DateTime? picked = await showCustomDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      final months = [
                        "January",
                        "February",
                        "March",
                        "April",
                        "May",
                        "June",
                        "July",
                        "August",
                        "September",
                        "October",
                        "November",
                        "December",
                      ];
                      controller.dobController.text =
                          "${months[picked.month - 1]} ${picked.day}, ${picked.year}";
                    }
                  },
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                    size: 20.w,
                  ),
                ),
                SizedBox(height: 16.h),

                // ── Location (editable) ─────────────────────────────────────
                _buildLabel(AppLocalizations.of(context)!.location),
                CustomTextFormField(
                  controller: controller.locationController,
                  hintText: AppLocalizations.of(context)!.enterLocation,
                  containerColor: Colors.white,
                  borderRedius: 12.w,
                ),
                SizedBox(height: 16.h),

                // ── Gender (editable) ───────────────────────────────────────
                _buildLabel(AppLocalizations.of(context)!.gender),
                Obx(
                  () => CustomDropdownField(
                    hintText: AppLocalizations.of(context)!.selectGender,
                    items: [
                      AppLocalizations.of(context)!.male,
                      AppLocalizations.of(context)!.female,
                      AppLocalizations.of(context)!.other,
                    ],
                    selectedValue: controller.selectedGender.value,
                    onChanged: controller.setGender,
                    radius: 12.w,
                  ),
                ),
                SizedBox(height: 40.h),

                // ── Save Button ─────────────────────────────────────────────
                Obx(() {
                  final isLoading = controller.isUpdatingProfile.value;
                  return CustomSubmitButton(
                    text: AppLocalizations.of(context)!.saveChanges,
                    textColor: Colors.white,
                    color: isLoading
                        ? const Color(0xFF040A18).withValues(alpha: 0.6)
                        : const Color(0xFF040A18),
                    borderRadius: BorderRadius.circular(30.w),
                    onTap: isLoading ? () {} : controller.updateUserProfile,
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CustomLoadingIndicator(),
                          )
                        : null,
                  );
                }),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
