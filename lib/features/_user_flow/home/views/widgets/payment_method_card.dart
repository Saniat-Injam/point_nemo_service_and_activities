import 'package:flutter/material.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final Widget logo;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.logo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8F9FE) : const Color(0xFFF3F4F6),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F1728) : Colors.transparent,
            width: isSelected ? 1.5 : 0.0,
          ),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Row(
          children: [
            logo,
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1B20),
                ),
              ),
            ),
            _buildRadioButton(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(bool selected) {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF0F1728) : const Color(0xFF6B7280),
          width: 1.5.w,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1728),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}


