import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_dropdown.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/captain_booking_details_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class CaptainBookingDetailsScreen extends StatelessWidget {
  const CaptainBookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaptainBookingDetailsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        title: Text(
          AppLocalizations.of(context)!.captainBookingDetails,
          style: getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.selectDate,
              style: getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D1B20),
              ),
            ),
            SizedBox(height: 24.h),

            // Date Fields
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.startDate,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => controller.selectStartDate(context),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            controller: controller.startDateController,
                            hintText: AppLocalizations.of(context)!.dateFormatHint,
                            containerColor: Colors.white,
                            containerBorderColor: const Color(0xFFE5E7EB),
                            borderRedius: 30.w,
                            hintTextStyle: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.endDate,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => controller.selectEndDate(context),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            controller: controller.endDateController,
                            hintText: AppLocalizations.of(context)!.dateFormatHint,
                            containerColor: Colors.white,
                            containerBorderColor: const Color(0xFFE5E7EB),
                            borderRedius: 30.w,
                            hintTextStyle: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Boat type Field
            Text(
              AppLocalizations.of(context)!.boatType,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1D1B20),
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomDropdownField(
                hintText: AppLocalizations.of(context)!.selectBoatType,
                items: controller.boatTypes,
                selectedValue: controller.selectedBoatType.value ?? '',
                onChanged: (String newValue) {
                  controller.setSelectedBoatType(newValue);
                },
                radius: 24.w,
                borderColor: const Color(0xFFE5E7EB),
                textColor: const Color(0xFF1D1B20),
                dropdownColor: Colors.white,
                bgColor: Colors.white,
              ),
            ),
            SizedBox(height: 32.h),

            // Summary Card
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  children: [
                    _buildSummaryRow(
                      AppLocalizations.of(context)!.subtotal,
                      '\$${controller.subTotal.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 16.h),
                    _buildSummaryRow(
                      AppLocalizations.of(context)!.serviceFee,
                      '\$${controller.serviceFee.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 16.h),
                    _buildSummaryRow(
                      AppLocalizations.of(context)!.extraFee,
                      '\$${controller.extraFee.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 24.h),
                    _buildSummaryRow(
                      AppLocalizations.of(context)!.totalText,
                      '\$${controller.totalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Obx(
            () => CustomSubmitButton(
              text: controller.isLoading.value ? AppLocalizations.of(context)!.processingText : AppLocalizations.of(context)!.payNow,
              onTap: controller.isLoading.value
                  ? () {}
                  : controller.hireCaptain,
              color: const Color(0xFF040A18),
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(30.w),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.w400,
            color: isTotal ? const Color(0xFF1D1B20) : const Color(0xFF4B5563),
          ),
        ),
        Text(
          value,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
      ],
    );
  }
}
