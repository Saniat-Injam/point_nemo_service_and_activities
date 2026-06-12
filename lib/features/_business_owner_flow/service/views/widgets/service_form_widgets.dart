import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

class ServiceFormWidgets {
  static Widget buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: text,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        textColor: AppColors.textPrimary,
      ),
    );
  }



  static Widget buildUploadSection({
    required String label,
    VoidCallback? onCameraTap,
    VoidCallback? onGalleryTap,
    List<dynamic> photos = const [], // Could be File from dart:io
  }) {
    return Column(
      children: [
        CustomPaint(
          painter: DashedRectPainter(
            color: const Color(0xFFE5E7EB),
            strokeWidth: 1,
            gap: 4,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 40.sp,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: label,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.textPrimary,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "Upload the front side of your docuement",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.textSecondary,
                ),
                CustomText(
                  text: "Supports: JPG, PNG, PDF",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.textSecondary,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUploadButton(Icons.camera_alt_outlined, "Take photo", onCameraTap),
                    SizedBox(width: 12.w),
                    _buildUploadButton(Icons.upload_outlined, "Choose a file", onGalleryTap),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             for (int i = 0; i < 3; i++)
               Padding(
                 padding: EdgeInsets.only(right: 12.w),
                 child: _buildImagePlaceholder(i, photos.length > i ? photos[i] : null),
               ),
           ],
         ),
      ],
    );
  }

  static Widget _buildUploadButton(IconData icon, String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF2C3131)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: const Color(0xFF2C3131)),
            SizedBox(width: 8.w),
            Text(
              text,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2C3131),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildImagePlaceholder(int index, dynamic photoFile) {
    return Container(
      width: 105.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        image: photoFile != null
            ? DecorationImage(
                image: FileImage(photoFile as dynamic), // dart:io File
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: photoFile == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 24.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                CustomText(
                  text: "Photo ${index + 1}",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            )
          : null,
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double x = size.width;
    final double y = size.height;
    final double radius = 16.0;

    final Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(x - radius, 0)
      ..arcToPoint(Offset(x, radius), radius: Radius.circular(radius))
      ..lineTo(x, y - radius)
      ..arcToPoint(Offset(x - radius, y), radius: Radius.circular(radius))
      ..lineTo(radius, y)
      ..arcToPoint(Offset(0, y - radius), radius: Radius.circular(radius))
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final Path dashPath = Path();
    final double dashWidth = gap;
    final double dashGap = gap;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashGap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
