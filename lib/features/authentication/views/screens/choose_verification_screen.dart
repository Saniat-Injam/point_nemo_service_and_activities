import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/features/authentication/controllers/choose_verification_controller.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ChooseVerificationScreen extends StatelessWidget {
  const ChooseVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChooseVerificationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // Header with back button and title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF1D1B20),
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.chooseVerificationMode,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ),
                  // Spacer to balance the back button
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 32.h),

              // Email option
              Obx(
                () => _VerificationOption(
                  label: AppLocalizations.of(context)!.email,
                  isSelected: controller.selectedMode.value == 'email',
                  onTap: () => controller.selectMode('email'),
                ),
              ),
              SizedBox(height: 16.h),

              // Phone option
              Obx(
                () => _VerificationOption(
                  label: AppLocalizations.of(context)!.phone,
                  isSelected: controller.selectedMode.value == 'phone',
                  onTap: () => controller.selectMode('phone'),
                ),
              ),

              const Spacer(),

              // Submit button
              CustomSubmitButton(
                text: AppLocalizations.of(context)!.submit,
                onTap: controller.submit,
                color: const Color(0xFF040A18),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(28.w),
                padding: EdgeInsets.symmetric(vertical: 18.h),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VerificationOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF040A18) : Colors.white,
          borderRadius: BorderRadius.circular(28.w),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF040A18)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF1D1B20),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
