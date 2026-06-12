import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/logger.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePaymentController extends GetxController {
  late final WebViewController webViewController;

  final isPageLoading = true.obs;
  final loadingProgress = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final String paymentUrl = Get.arguments?['url'] ?? '';
    log('StripePaymentController - Loading URL: $paymentUrl');

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            log('Stripe WebView - Page started: $url');
            isPageLoading.value = true;
          },
          onProgress: (int progress) {
            loadingProgress.value = progress;
          },
          onPageFinished: (String url) {
            log('Stripe WebView - Page finished: $url');
            isPageLoading.value = false;
            _checkForPaymentCompletion(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            log('Stripe WebView - Navigation request: ${request.url}');
            _notifyBackend(request.url);
            if (_isPaymentComplete(request.url)) {
              _handlePaymentResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            log('Stripe WebView - Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  /// Check if the URL indicates payment completion
  bool _isPaymentComplete(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('payment_success') ||
        lowerUrl.contains('payment_cancel') ||
        lowerUrl.contains('payment-success') ||
        lowerUrl.contains('payment-cancel') ||
        lowerUrl.contains('/success') ||
        lowerUrl.contains('/cancel') ||
        lowerUrl.contains('status=success') ||
        lowerUrl.contains('status=cancel') ||
        lowerUrl.contains('status=complete') ||
        (lowerUrl.contains('206.162.244.142') &&
            !lowerUrl.contains('checkout.stripe.com'));
  }

  /// Check on page finish too (for redirects that NavigationDelegate misses)
  void _checkForPaymentCompletion(String url) {
    if (_isPaymentComplete(url)) {
      _handlePaymentResult(url);
    }
  }

  /// Handle the payment result based on URL
  void _handlePaymentResult(String url) {
    final lowerUrl = url.toLowerCase();
    final isSuccess =
        lowerUrl.contains('success') || lowerUrl.contains('complete');

    log('Stripe Payment Result - isSuccess: $isSuccess, URL: $url');

    // Allow callers to pass custom messages via arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final successMessage =
        args['successMessage'] as String? ?? 'Payment successful!';
    final cancelMessage =
        args['cancelMessage'] as String? ?? 'Payment was cancelled.';

    if (isSuccess) {
      Get.offAllNamed(AppRoute.mainBottomNavBar);
      AppHelperFunctions.showSnackBar(successMessage, isError: false);
    } else {
      Get.back();
      AppHelperFunctions.showSnackBar(cancelMessage);
    }
  }

  /// Show cancel confirmation dialog
  void showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Payment?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1B20),
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel the payment?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Continue Payment',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF040A18),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.back();
              AppHelperFunctions.showSnackBar("Payment cancelled.");
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _notifyBackend(String confirmUrl) async {
    try {
      final response = await NetworkCaller().postRequest(confirmUrl, body: {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLoggerHelper.info("Payment successful");
      }
    } catch (e) {
      AppLoggerHelper.error("Notify error: $e");
    }
  }
}
