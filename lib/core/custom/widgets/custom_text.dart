import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizes.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? decorationThickness;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final Color? decorationColor;

  const CustomText({
    super.key,
    required this.text,
    this.textAlign,
    this.decorationThickness,
    this.maxLines,
    this.textOverflow,
    this.fontSize,
    this.textColor,
    this.fontWeight,
    this.decoration,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        decoration: decoration,
        decorationThickness: decorationThickness,
        decorationColor: decorationColor ?? const Color(0xff2972FF),
        fontSize: fontSize ?? getWidth(14),
        color: textColor ?? AppColors.textPrimary,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
