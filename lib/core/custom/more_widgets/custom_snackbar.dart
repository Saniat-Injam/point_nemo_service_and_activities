import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';

class CustomSnackBar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: isError ? AppColors.error : AppColors.success,
        colorText: AppColors.textWhite,
        titleText: Text(
          title,
          style: getTextStyle(
            color: AppColors.textWhite,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          message,
          style: getTextStyle(
            color: AppColors.textWhite,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: AppColors.textWhite,
          size: 28.w,
        ),
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.w,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    });
  }

  static void showSuccess({required String message, String title = 'Success'}) {
    show(title: title, message: message, isError: false);
  }

  static void showError({required String message, String title = 'Error'}) {
    show(title: title, message: message, isError: true);
  }
}
