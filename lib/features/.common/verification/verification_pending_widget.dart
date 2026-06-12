import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';

class VerificationPendingWidget extends StatelessWidget {
  final String submissionDate;
  final VoidCallback onSupportPressed;

  const VerificationPendingWidget({
    super.key,
    required this.submissionDate,
    required this.onSupportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        // Verification Pending Card
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40.h),
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 30.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF8B6E30), width: 1.5),
                borderRadius: BorderRadius.circular(24.w),
              ),
              child: Column(
                children: [
                  Text(
                    'Verification Pending',
                    style: getTextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B6E30),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4B5563),
                        height: 1.5,
                      ),
                      children: const [
                        TextSpan(text: 'Your account is under review. Once '),
                        TextSpan(
                          text: 'approved',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ',\n'),
                        TextSpan(text: 'you can start '),
                        TextSpan(
                          text: 'managing your services',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Submitted On: $submissionDate',
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8B6E30), width: 1.5),
              ),
              padding: EdgeInsets.all(12.w),
              child: Image.asset(ImagePath.hourglass),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        // Status Details Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(24.w),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            children: [
              _buildStatusItem(
                icon: Icons.assignment_outlined,
                text: 'Documents are under verification',
              ),
              const Divider(color: Color(0xFFE5E7EB), height: 32),
              _buildStatusItem(
                icon: Icons.mail_outline,
                text: "You'll be notified via app & email",
              ),
              const Divider(color: Color(0xFFE5E7EB), height: 32),
              Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF040A18),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF040A18),
                        ),
                        children: const [
                          TextSpan(text: 'Contact '),
                          TextSpan(
                            text: 'Support',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onSupportPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF040A18),
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.headset_mic_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Support',
                            style: getTextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  Widget _buildStatusItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF040A18)),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF040A18),
            ),
          ),
        ),
      ],
    );
  }
}
