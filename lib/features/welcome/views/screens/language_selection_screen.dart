import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/features/welcome/controllers/language_selection_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LanguageSelectionController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.06),

              // Welcome Title
              Center(
                child: Text(
                  AppLocalizations.of(context)!.welcome,
                  style: getTextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF040A18),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Subtitle
              Center(
                child: Text(
                  AppLocalizations.of(context)!.personalizeExp,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.045),

              // Select Language Header with Globe Icon
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 20.w,
                    color: const Color(0xFF040A18),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppLocalizations.of(context)!.selectLanguage,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF040A18),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Language Options
              Obx(
                () => Column(
                  children: controller.languages.map((lang) {
                    final isSelected =
                        controller.selectedLanguage.value == lang['code'];
                    
                    // Translate language names dynamically based on selected language
                    String localizedName = lang['name']!;
                    if (lang['code'] == 'en') {
                      localizedName = AppLocalizations.of(context)!.english;
                    } else if (lang['code'] == 'ar') {
                      localizedName = AppLocalizations.of(context)!.arabic;
                    }

                    return _LanguageOptionTile(
                      name: localizedName,
                      flagPath: lang['flag']!,
                      isSelected: isSelected,
                      onTap: () => controller.selectLanguage(lang['code']!),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),

              // Continue Button
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.03),
                child: CustomSubmitButton(
                  text: AppLocalizations.of(context)!.continueText,
                  onTap: controller.onContinue,
                  color: const Color(0xFF040A18),
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(28.w),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual language option tile widget
class _LanguageOptionTile extends StatelessWidget {
  final String name;
  final String flagPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.name,
    required this.flagPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF040A18) : Colors.white,
            borderRadius: BorderRadius.circular(28.w),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF040A18)
                  : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Flag image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: Image.asset(
                  flagPath,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 12.w),

              // Language name
              Expanded(
                child: Text(
                  name,
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF040A18),
                  ),
                ),
              ),

              // Radio indicator
              Container(
                width: 22.w,
                height: 22.w,
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
      ),
    );
  }
}
