import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_dropdown.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_outline_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/controllers/business_owner_service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/views/screens/create_or_edit_service_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/controllers/create_or_edit_service_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class BusinessOwnerServiceScreen extends StatelessWidget {
  const BusinessOwnerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessOwnerServiceController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: AppLocalizations.of(context)!.servicesText,
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          textColor: AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Category Selector ──────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppLocalizations.of(context)!.categoryText,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      textColor: const Color(0xFF0B1426),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => CustomDropdownField(
                        bgColor: AppColors.primary,
                        hintText: '',
                        textColor: AppColors.textWhite,
                        dropdownColor: AppColors.textWhite,
                        items: controller.sportsList,
                        selectedValue: controller.selectedSports.value,
                        onChanged: (value) {
                          controller.selectedSports.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // ── My Services title ──────────────────────────────────────
              CustomText(
                text: AppLocalizations.of(context)!.myServicesText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                textColor: const Color(0xFF0B1426),
              ),
              SizedBox(height: 16.h),

              // ── Service List ───────────────────────────────────────────
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CustomLoadingIndicator());
                  }

                  if (controller.services.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_outlined,
                            size: 64.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16.h),
                          CustomText(
                            text: AppLocalizations.of(context)!.noServicesFound,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.textSecondary,
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: AppLocalizations.of(context)!.addFirstServicePrompt,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: controller.scrollController,
                    shrinkWrap: false,
                    itemCount: controller.services.length +
                        (controller.hasMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (_, index) {
                      // Load-more indicator at the bottom
                      if (index == controller.services.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(child: CustomLoadingIndicator()),
                        );
                      }
                      final service = controller.services[index];
                      return _ServiceCard(
                        service: service,
                        fallbackImage:
                            controller.getFallbackImage(service.type),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 20.h,
            top: 10.h,
          ),
          child: CustomSubmitButton(
            text: '',
            onTap: () {
              final selected = controller.selectedSports.value;
              final createController = Get.put(CreateServiceController());
              createController.clearData();
              
              Get.to(
                () => CreateServiceScreen(
                  title: selected,
                ),
              );
            },
            borderRadius: BorderRadius.circular(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_box_outlined,
                  size: 24.sp,
                  color: AppColors.textWhite,
                ),
                SizedBox(width: 10.w),
                Text(
                  AppLocalizations.of(context)!.createServicesText,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Service Card ──────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.fallbackImage,
  });

  final ServiceModel service;
  final String fallbackImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Thumbnail ───────────────────────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: service.coverImage.isNotEmpty
                        ? Image.network(
                            service.coverImage,
                            height: 120.h,
                            width: 120.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              fallbackImage,
                              height: 120.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            fallbackImage,
                            height: 120.h,
                            width: 120.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      child: CustomText(
                        text: _typeLabel(service.type, context),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),

              // ── Info ─────────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: service.name,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.textPrimary,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      text: service.description,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.textSecondary,
                      maxLines: 2,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: CustomText(
                            text: service.address,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.textSecondary,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: '\$${service.price.toStringAsFixed(2)}',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.textPrimary,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFEAF9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomText(
                            text: AppLocalizations.of(context)!.availableText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            textColor: const Color(0xFF040A18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(color: Color(0xFFE5E7EB), thickness: 1),
          SizedBox(height: 16.h),
          CustomOutlineButton(
            onPressed: () {
              final createController = Get.put(CreateServiceController());
              createController.loadDataForEdit(service.id);
              
              String typeLabel = _typeLabel(service.type, context);
              Get.to(() => CreateServiceScreen(
                    title: typeLabel,
                  ));
            },
            text: AppLocalizations.of(context)!.editText,
            borderColor: AppColors.primary,
            containerPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type, BuildContext context) {
    switch (type) {
      case 'BOAT_RENTAL':
        return AppLocalizations.of(context)!.boatRentalText;
      case 'WATER_SPORTS':
        return AppLocalizations.of(context)!.waterSportsText;
      case 'DIVING_COURSE':
        return AppLocalizations.of(context)!.divingCourseText;
      case 'FISHING_TRIP':
        return AppLocalizations.of(context)!.fishingTripText;
      default:
        return type;
    }
  }
}
