import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_booking_details_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/utils/validators/app_validator.dart';

class ServiceBookingDetailsScreen extends StatelessWidget {
  const ServiceBookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceBookingDetailsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
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
          AppLocalizations.of(context)!.serviceBookingDetails,
          style: getTextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            bottom: 24.h,
            top: 16.h,
          ),
          child: Obx(
            () => GestureDetector(
              onTap: controller.isLoading.value ? null : controller.submitBooking,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: controller.isLoading.value
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF040A18),
                  borderRadius: BorderRadius.circular(32.w),
                ),
                child: Text(
                  controller.isLoading.value ? AppLocalizations.of(context)!.processingText : AppLocalizations.of(context)!.continueToPayment,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
            Text(
              AppLocalizations.of(context)!.selectDateAndTime,
              style: getTextStyle(
                fontSize: 20.sp,
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
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () => controller.selectStartDate(context),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            controller: controller.startDateController,
                            hintText: AppLocalizations.of(context)!.dateFormatHint,
                            containerColor: Colors.white,
                            containerBorderColor: const Color(0xFFE5E7EB),
                            borderRedius: 30.w,
                            validation: (v) => AppValidator.validateNotEmptyWithAll(v, 'Date'),
                            hintTextStyle: getTextStyle(
                              fontSize: 14.sp,
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
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () => controller.selectEndDate(context),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            controller: controller.endDateController,
                            hintText: AppLocalizations.of(context)!.dateFormatHint,
                            containerColor: Colors.white,
                            containerBorderColor: const Color(0xFFE5E7EB),
                            borderRedius: 30.w,
                            validation: (v) => AppValidator.validateNotEmptyWithAll(v, 'Date'),
                            hintTextStyle: getTextStyle(
                              fontSize: 14.sp,
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
            SizedBox(height: 24.h),

            // Number of Guests Section
            Obx(() {
              if (controller.isBoatRental.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.numberOfGuests,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      controller: controller.guestsController,
                      hintText: '00',
                      containerColor: Colors.white,
                      containerBorderColor: const Color(0xFFE5E7EB),
                      borderRedius: 30.w,
                      keyboardType: TextInputType.number,
                      validation: (v) => AppValidator.validateNumberOnly(v, 'Capacity'),
                      hintTextStyle: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // Price Summary Section
            Obx(() {
              final days = controller.numberOfDays;
              final pricePerDay = controller.pricePerDay.value;
              final sub = controller.subtotal;
              final tot = controller.total;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Column(
                  children: [
                    _buildPriceRow(
                      '\$${pricePerDay.toStringAsFixed(2)} × $days day${days > 1 ? 's' : ''}',
                      '\$${sub.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 20.h),
                    Divider(
                      color: const Color(0xFFE5E7EB),
                      height: 1,
                      thickness: 1,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.totalText,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                        Text(
                          '\$${tot.toStringAsFixed(2)}',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF040A18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        Text(
          price,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1B20),
          ),
        ),
      ],
    );
  }
}
