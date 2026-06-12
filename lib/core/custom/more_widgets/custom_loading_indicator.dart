import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: SpinKitSpinningLines(color: AppColors.primary, size: 40.h),
      child: SizedBox(
        height: 30.h,
        width: 30.w,
        child: LoadingIndicator(
          indicatorType: Indicator.lineScalePulseOut,
          strokeWidth: 2,
          // pathBackgroundColor: AppColors.btnBlueBorder,
          colors: [
            AppColors.primary,
            AppColors.success,
            AppColors.error,
            AppColors.warning,
          ],
          pause: false,
        ),
      ),
    );
  }
}
