import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/features/onboarding/controllers/onboarding_controller.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/features/onboarding/models/onboarding_model.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    final l = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final pages = [
      OnboardingModel(
        imagePath: ImagePath.onboarding1,
        title: l.rentBoatsText,
        subtitle: l.onboarding1Subtitle,
      ),
      OnboardingModel(
        imagePath: ImagePath.onboarding2,
        title: l.waterSportsText2,
        subtitle: l.onboarding2Subtitle,
      ),
      OnboardingModel(
        imagePath: ImagePath.onboarding3,
        title: l.divingSnorkelingText,
        subtitle: l.onboarding3Subtitle,
      ),
      OnboardingModel(
        imagePath: ImagePath.onboarding4,
        title: l.fishingTripsText,
        subtitle: l.onboarding4Subtitle,
      ),
      OnboardingModel(
        imagePath: ImagePath.onboarding5,
        title: l.hireCaptains,
        subtitle: l.onboarding5Subtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Image PageView (Top Portion)
          PageView.builder(
            controller: controller.imagePageController,
            onPageChanged: controller.updatePageIndicator,
            itemCount: pages.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.6,
                    child: Image.asset(
                      pages[index].imagePath,
                      fit: BoxFit.cover,
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
                ],
              );
            },
          ),

          // 2. Fixed White Curved Container at Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height:
                screenHeight * 0.5, // 50% height as per visual balance in image
            child: ClipPath(
              clipper: OnboardingCurveClipper(),
              child: Container(color: Colors.white),
            ),
          ),

          // 3. Text Content PageView (Synced with Image PageView)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: PageView.builder(
              controller: controller.textPageController,
              onPageChanged: controller.updatePageIndicator,
              itemCount: pages.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final page = pages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 70.h), // Spacing from curve peak
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1D1B20),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF49454F),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 4. Skip Button (Top Right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: Obx(() {
              return controller.currentPageIndex.value <
                      pages.length - 1
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25.w),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: GestureDetector(
                          onTap: controller.skipPage,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 22.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(25.w),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              l.skipText,
                              style: getTextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ),

          // 5. Dots Indicator (Fixed position, relative to white container)
          Positioned(
            bottom: bottomPadding + 180.h, // Adjusted to be closer to subtitle
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 8.w,
                    width: 8.w,
                    decoration: BoxDecoration(
                      color: controller.currentPageIndex.value == index
                          ? const Color(0xFF040A18)
                          : const Color(0xFFE5E5E5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 6. Next Button (Bottom)
          Positioned(
            bottom: bottomPadding + 24.h,
            left: 24.w,
            right: 24.w,
            child: CustomSubmitButton(
              text: l.nextText,
              onTap: controller.nextPage,
              color: const Color(0xFF040A18),
              borderRadius: BorderRadius.circular(35.w),
              textColor: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              padding: EdgeInsets.symmetric(vertical: 18.h),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 60.0; // Slightly more pronounced curve
    path.lineTo(0, curveHeight);
    path.quadraticBezierTo(size.width / 2, 0, size.width, curveHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
