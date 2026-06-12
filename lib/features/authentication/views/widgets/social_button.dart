import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

class SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.iconWidget,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF1D1B20), width: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.w),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 24.w,
                width: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF1D1B20),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconWidget,
                  SizedBox(width: 12.w),
                  Text(
                    text,
                    style: getTextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
