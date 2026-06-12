import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizes.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? titleSize;
  final Color? titleColor;
  final FontWeight? titleWeight;
  final double? titlePadding;
  final Widget? leading;
  final Widget? action;
  final Color? backgroundColor;
  final double? height;
  final double? borderRadius;
  final bool? enableShadow;
  final double? shadowBlurRadius;
  final Color? shadowColor;
  final bool showBackIcon;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleSize,
    this.titleColor,
    this.titleWeight,
    this.titlePadding,
    this.leading,
    this.action,
    this.backgroundColor = AppColors.primary,
    this.height = kToolbarHeight + 12,
    this.borderRadius = 50,
    this.enableShadow = false,
    this.shadowBlurRadius = 6.0,
    this.shadowColor = Colors.black26,
    this.showBackIcon = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius!),
          bottomRight: Radius.circular(borderRadius!),
        ),
        boxShadow: enableShadow == true
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.black26,
                  blurRadius: shadowBlurRadius!,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: centerTitle,
        leading: showBackIcon
            ? Container(
                decoration: BoxDecoration(
                  color: Color(0xffEEF2F6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigator.pop(context);
                    Get.back();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              )
            : null,
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: titlePadding ?? getWidth(8),
          ),
          child: CustomText(
            text: title ?? '',
            textColor: titleColor ?? AppColors.textPrimary,
            fontSize: titleSize ?? getWidth(20),
            fontWeight: titleWeight ?? FontWeight.bold,
          ),
        ),
        actions: action != null ? [action!] : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height!);
}
