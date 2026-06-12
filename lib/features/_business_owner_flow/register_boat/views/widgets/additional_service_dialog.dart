import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';


class AdditionalServiceDialog {
  static void show({
    required TextEditingController nameController,
    required TextEditingController priceController,
    required VoidCallback onAdd,
    required BuildContext context,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  AppLocalizations.of(context)!.additionalService,
                  style: getTextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              // Subtitle
              Center(
                child: Text(
                  AppLocalizations.of(context)!.enterAdditionalServiceSubtitle,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Service name label
              Text(
                AppLocalizations.of(context)!.serviceNameText,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 8.h),
              // Service name text field
              _buildTextField(
                controller: nameController,
                hintText: AppLocalizations.of(context)!.enterServiceNameHint,
              ),
              SizedBox(height: 20.h),
              // Service price label
              Text(
                AppLocalizations.of(context)!.servicePriceText,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 8.h),
              // Service price text field
              _buildTextField(
                controller: priceController,
                hintText: AppLocalizations.of(context)!.enterPriceHint,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 28.h),
              // Set service button
              _buildSetServiceButton(onAdd, context),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: getTextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFBCC1CA),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.w),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.w),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.w),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static Widget _buildSetServiceButton(VoidCallback onAdd, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onAdd();
        Get.back();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(50.w),
        ),
        child: Text(
          AppLocalizations.of(context)!.setServiceText,
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
