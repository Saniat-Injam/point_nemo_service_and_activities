import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/role_selection_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoleSelectionController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              // Image illustration
              Expanded(
                flex: 3,
                child: Image.asset(
                  ImagePath.roleSelection,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                AppLocalizations.of(context)!.chooseYourRole,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppLocalizations.of(context)!.chooseHowToUse,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF49454F),
                ),
              ),
              SizedBox(height: 32.h),

              // Role options
              _buildRoleOption(controller, index: 0, title: AppLocalizations.of(context)!.userRole),
              SizedBox(height: 16.h),
              _buildRoleOption(controller, index: 1, title: AppLocalizations.of(context)!.businessOwnerRole),
              SizedBox(height: 16.h),
              _buildRoleOption(controller, index: 2, title: AppLocalizations.of(context)!.captainRole),

              SizedBox(height: 32.h),

              // Hide Guest option when arriving from Google sign-in flow
              if (!controller.fromSocial)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF49454F),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.exploreAsGuest,
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: controller.onGuestPressed,
                            child: Text(
                              AppLocalizations.of(context)!.guest,
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: const Color(0xFF49454F),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              // Continue button — shows loader during Google API call
              Obx(() {
                if (controller.isLoading.value) {
                  return const CustomLoadingIndicator();
                }
                return CustomSubmitButton(
                  text: AppLocalizations.of(context)!.continueText,
                  onTap: controller.onContinuePressed,
                  color: const Color(0xFF040A18),
                  borderRadius: BorderRadius.circular(30.w),
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(
    RoleSelectionController controller, {
    required int index,
    required String title,
  }) {
    return Obx(() {
      final isSelected = controller.selectedRoleIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectRole(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF040A18) : Colors.white,
            borderRadius: BorderRadius.circular(30.w),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF040A18)
                  : const Color(0xFFCECECE),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1D1B20),
                ),
              ),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : const Color(0xFF49454F),
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
