import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_intl_phone_field.dart';import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_dropdown.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/upload_area_widget.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/profile_setup_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  void _showSelectProfileImageBottomSheet(
    BuildContext context,
    ProfileSetupController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectProfileImage,
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: 24.w,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.pickProfileImageFromGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            size: 32.w,
                            color: const Color(0xFF040A18),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          AppLocalizations.of(context)!.photoGallery,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF040A18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.takeProfilePhoto();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 32.w,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          AppLocalizations.of(context)!.takePhoto,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileSetupController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.profileSetup,
        backgroundColor: Colors.white,
        showBackIcon: true,
        centerTitle: false,
        titleColor: const Color(0xFF1D1B20),
        titleSize: 24.sp,
        titleWeight: FontWeight.w600,
        enableShadow: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingProfile.value) {
            return const CustomLoadingIndicator();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // Profile Avatar
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        _showSelectProfileImageBottomSheet(context, controller),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(
                          () => Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                              image:
                                  controller.profileImagePath.value.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(controller.profileImagePath.value),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: controller.profileImagePath.value.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 60.w,
                                    color: const Color(0xFFE5E7EB),
                                  )
                                : null,
                          ),
                        ),
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF040A18),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Full Name
                Text(
                  AppLocalizations.of(context)!.fullName,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.fullNameController,
                  hintText: 'Michel Jhon', // used hint instead of initial val
                  keyboardType: TextInputType.name,
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Email
                Text(
                  AppLocalizations.of(context)!.email,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.emailController,
                  hintText: 'micheljhon@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  readonly: true,
                  containerColor: const Color(
                    0xFFF9FAFB,
                  ), // Softer grey for readOnly
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 16.h),

                // Phone Number
                Text(
                  AppLocalizations.of(context)!.phoneNumber,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                IgnorePointer(
                  child: CustomIntlPhoneField(
                    initialValue:
                        controller.phoneController.text.startsWith('+')
                        ? controller.phoneController.text
                        : (controller.phoneController.text.isNotEmpty
                              ? '+${controller.phoneController.text}'
                              : null),
                    readOnly: true,
                    showCursor: false,
                    hintText: '907) 555-0101',
                    counterText: '',
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                ),
                SizedBox(height: 16.h),

                // Gender
                Text(
                  AppLocalizations.of(context)!.gender,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => CustomDropdownField(
                    hintText: AppLocalizations.of(context)!.selectGender,
                    items: [AppLocalizations.of(context)!.male, AppLocalizations.of(context)!.female, AppLocalizations.of(context)!.other],
                    selectedValue: controller.selectedGender.value,
                    onChanged: (val) => controller.setGender(val),
                    radius: 28.w,
                    bgColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),

                // Location
                Text(
                  AppLocalizations.of(context)!.location,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.locationController,
                  hintText: AppLocalizations.of(context)!.writeHere,
                  containerColor: Colors.white,
                  containerBorderColor: const Color(0xFFE5E7EB),
                  borderRedius: 28.w,
                ),
                SizedBox(height: 24.h),

              if (controller.roleIndex == 2) ...[
                // Upload NID
                Text(
                  AppLocalizations.of(context)!.uploadNid,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => UploadAreaWidget(
                    title: AppLocalizations.of(context)!.uploadYourNid,
                    subtitle: AppLocalizations.of(context)!.uploadDocumentSubtitle,
                    onTakePhoto: controller.takeNidPhoto,
                    onChooseFile: controller.pickNidImage,
                    selectedFileName: controller.nidImagePath.value.isNotEmpty
                        ? controller.nidImagePath.value.split('/').last
                        : null,
                    onRemove: controller.nidImagePath.value.isNotEmpty
                        ? () => controller.nidImagePath.value = ''
                        : null,
                  ),
                ),
                SizedBox(height: 24.h),

                // Upload Documents
                Text(
                  AppLocalizations.of(context)!.uploadDocuments,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => UploadAreaWidget(
                    title: AppLocalizations.of(context)!.uploadYourDocuments,
                    subtitle: AppLocalizations.of(context)!.uploadDocumentSubtitle,
                    onTakePhoto: controller.takeDocsPhoto,
                    onChooseFile: controller.pickDocsImage,
                    selectedFileName: controller.docsImagePaths.isNotEmpty
                        ? '${controller.docsImagePaths.length} ${AppLocalizations.of(context)!.filesSelected}'
                        : null,
                    onRemove: controller.docsImagePaths.isNotEmpty
                        ? () => controller.docsImagePaths.clear()
                        : null,
                  ),
                ),

                SizedBox(height: 32.h),
              ],

                // Continue Button
                Obx(
                  () => controller.isUpdatingProfile.value
                      ? const CustomLoadingIndicator()
                      : CustomSubmitButton(
                          text: AppLocalizations.of(context)!.continueText,
                          onTap: controller.submitProfile,
                          color: const Color(0xFF040A18),
                          textColor: Colors.white,
                          borderRadius: BorderRadius.circular(28.w),
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                        ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
