import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/stripe_payment/controllers/stripe_payment_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePaymentScreen extends GetView<StripePaymentController> {
  const StripePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Center(
            child: GestureDetector(
              onTap: () => controller.showCancelDialog(context),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF1D1B20),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 60.w,
        title: Text(
          'Payment',
          style: getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1B20),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webViewController),

          // Loading progress bar
          Obx(() {
            if (!controller.isPageLoading.value) {
              return const SizedBox.shrink();
            }
            return Obx(() {
              return LinearProgressIndicator(
                value: controller.loadingProgress.value / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF040A18),
                ),
                minHeight: 3,
              );
            });
          }),
        ],
      ),
    );
  }
}
