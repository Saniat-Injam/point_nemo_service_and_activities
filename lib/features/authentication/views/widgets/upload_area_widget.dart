import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';

class UploadAreaWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFile;
  final String? selectedFileName;
  final VoidCallback? onRemove;

  const UploadAreaWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTakePhoto,
    required this.onChooseFile,
    this.selectedFileName,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Column(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 40.w,
                color: const Color(0xFF4B5563),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              if (selectedFileName != null && selectedFileName!.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8.w),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: const Color(0xFF059669),
                        size: 24.w,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          selectedFileName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (onRemove != null)
                        GestureDetector(
                          onTap: onRemove,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 20.w,
                          ),
                        )
                      else
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF059669),
                          size: 20.w,
                        ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onTakePhoto,
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 16.w,
                        color: const Color(0xFF4B5563),
                      ),
                      label: Text(
                        'Take photo',
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: const BorderSide(
                          color: Color(0xFF1D1B20),
                          width: 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onChooseFile,
                      icon: Icon(
                        Icons.cloud_upload_outlined,
                        size: 16.w,
                        color: const Color(0xFF4B5563),
                      ),
                      label: Text(
                        'Choose a file',
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: const BorderSide(
                          color: Color(0xFF1D1B20),
                          width: 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
