import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizes.dart';

Future<void> loadingProgressIndicator({String? title}) async {
  if (!(Get.isDialogOpen ?? false)) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.primary,
        insetPadding: EdgeInsets.symmetric(horizontal: getWidth(150)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(8),
            vertical: getHeight(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SpinKitSpinningLines(
                  color: AppColors.textWhite,
                  // waveColor: AppColors.textWhite,
                  size: getHeight(60),
                ),
              ),
              SizedBox(height: getHeight(8)),
              CustomText(
                text: title ?? "processing".tr,
                textColor: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                // fontSize: 12.sp,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }
  await Future.delayed(Duration(milliseconds: 1500));
}

Future<void> hideProgressIndicator() async {
  if (Get.isDialogOpen ?? false) {
    try {
      Get.back();
    } catch (e) {
      // Already closed or error while closing
    }
  }
}
