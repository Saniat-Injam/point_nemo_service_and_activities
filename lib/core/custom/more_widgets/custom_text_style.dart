import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

TextStyle getTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  TextAlign? textAlign,
  Color? color,
  int? maxLines,
  TextOverflow? textOverflow,
  TextDecoration? decoration,
  double? decorationThickness,
  Color? decorationColor,
  double? letterSpacing,
}) {
  return GoogleFonts.outfit(
    fontSize: fontSize ?? 14.sp,
    fontWeight: fontWeight ?? FontWeight.w600,
    //height: lineHeight != null ? (lineHeight / fontSize!) : 1.3,
    height: height ?? 1.3,
    color: color ?? AppColors.textPrimary,
    decoration: decoration,
    decorationThickness: decorationThickness,
    decorationColor: decorationColor ?? const Color(0xff2972FF),
    letterSpacing: letterSpacing,
  );
}

TextStyle getTextStyle2({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  TextAlign? textAlign,
  Color? color,
  int? maxLines,
  TextOverflow? textOverflow,
  TextDecoration? decoration,
  double? decorationThickness,
  Color? decorationColor,
  double? letterSpacing,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize ?? 14.sp,
    fontWeight: fontWeight ?? FontWeight.w600,
    //height: lineHeight != null ? (lineHeight / fontSize!) : 1.3,
    height: height ?? 1.3,
    color: color ?? AppColors.textPrimary,
    decoration: decoration,
    decorationThickness: decorationThickness,
    decorationColor: decorationColor ?? const Color(0xff2972FF),
    letterSpacing: letterSpacing,
  );
}
