import 'package:flutter/material.dart';

import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';

class CustomChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const CustomChatMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) // Bot tail on the left
            CustomPaint(
              size: Size(10.w, 18.h),
              painter: _LeftTailPainter(color: Colors.white),
            ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFFE5E7EB) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w),
                    bottomRight: Radius.circular(isUser ? 0 : 20.w),
                    bottomLeft: Radius.circular(isUser ? 20.w : 0),
                  ),
                ),
                child: Text(
                  text,
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary, // Dark text like the image
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          if (isUser) // User tail on the right
            CustomPaint(
              size: Size(10.w, 18.h),
              painter: _RightTailPainter(color: const Color(0xFFE5E7EB)),
            ),
        ],
      ),
    );
  }
}

class _LeftTailPainter extends CustomPainter {
  final Color color;

  _LeftTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width, 0); // Start at top right
    path.quadraticBezierTo(
      size.width,
      size.height * 0.6, // Vertical tangent start
      0,
      size.height, // End at bottom left
    );
    path.lineTo(size.width, size.height); // Horizontal bottom
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RightTailPainter extends CustomPainter {
  final Color color;

  _RightTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0); // Start at top left
    path.quadraticBezierTo(
      0,
      size.height * 0.6, // Vertical tangent start
      size.width,
      size.height, // End at bottom right
    );
    path.lineTo(0, size.height); // Horizontal bottom
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


