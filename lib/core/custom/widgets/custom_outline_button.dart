import 'package:flutter/material.dart';

import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizes.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.text,
    this.icon,
    this.borderColor,
    this.containerWidth,
    this.containerPadding,
    required this.onPressed,
  });

  final String? text;
  final Widget? icon;
  final Color? borderColor;
  final double? containerWidth;
  final EdgeInsetsGeometry? containerPadding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withValues(alpha: 0.5),
        onTap: onPressed,
        child: Container(
          width: containerWidth,
          padding:
              containerPadding ??
              EdgeInsets.symmetric(
                vertical: getHeight(17),
                horizontal: getWidth(16),
              ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: borderColor ?? AppColors.primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                const SizedBox(),
                SizedBox(
                  height: getHeight(23),
                  width: getWidth(23),
                  child: icon!,
                ),
              ],
              // SizedBox(
              //   width: getWidth(12),
              // ),
              CustomText(
                text: text ?? '',
                fontSize: getWidth(16),
                fontWeight: FontWeight.w600,
                textColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
