import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/logo_path.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/payment_methods_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/widgets/payment_method_card.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/booking_successful_screen.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentMethodsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),
            // Image
            _buildImage(),
            // Bottom Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.w),
                    topRight: Radius.circular(32.w),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    _buildPaymentsHeader(context),
                    SizedBox(height: 32.h),
                    _buildPaymentOptions(context, controller),
                    const Spacer(),
                    _buildContinueButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4D4D4),
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
          Text(
            AppLocalizations.of(context)!.detailsText,
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D1B20),
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.favorite_border,
              color: Color(0xFF1D1B20),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.w),
        child: Image.asset(
          ImagePath.rentBoat1,
          width: double.infinity,
          height: 180.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPaymentsHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
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
          Text(
            AppLocalizations.of(context)!.paymentsText,
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D1B20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions(BuildContext context, PaymentMethodsController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.selectPaymentMethods,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF1D1B20),
              ),
            ),
            SizedBox(height: 16.h),
            PaymentMethodCard(
              title: AppLocalizations.of(context)!.creditCard,
              logo: Image.asset(LogoPath.mastercard, width: 34.w),
              isSelected:
                  controller.selectedPaymentMethod.value == 'Credit card',
              onTap: () => controller.selectPaymentMethod('Credit card'),
            ),
            SizedBox(height: 16.h),
            PaymentMethodCard(
              title: AppLocalizations.of(context)!.debitCard,
              logo: Image.asset(LogoPath.visa, width: 34.w),
              isSelected:
                  controller.selectedPaymentMethod.value == 'Debit card',
              onTap: () => controller.selectPaymentMethod('Debit card'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        16.h,
        24.w,
        MediaQuery.of(context).padding.bottom + 24.h,
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const BookingSuccessfulScreen());
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1728),
            borderRadius: BorderRadius.circular(32.w),
          ),
          child: Text(
            AppLocalizations.of(context)!.continueToPayment,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


