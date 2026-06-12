import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_intl_phone_field.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/login_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/google_auth_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/apple_auth_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/social_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/utils/validators/app_validator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final googleAuthController = Get.find<GoogleAuthController>();
    final appleAuthController = Get.find<AppleAuthController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Button and Title
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
                    SizedBox(width: 20.w),
                    Text(
                      AppLocalizations.of(context)!.signIn,
                      style: getTextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D1B20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Email / Phone Switcher
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final isEmail = controller.isEmailSelected.value;
                          return GestureDetector(
                            onTap: () => controller.toggleLoginMethod(true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isEmail
                                    ? const Color(0xFF040A18)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12.w),
                                border: Border.all(
                                  color: isEmail
                                      ? const Color(0xFF040A18)
                                      : const Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      color: isEmail
                                          ? Colors.white
                                          : const Color(0xFF040A18),
                                      size: 18.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      AppLocalizations.of(context)!.email,
                                      style: getTextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isEmail
                                            ? Colors.white
                                            : const Color(0xFF040A18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Obx(() {
                          final isPhone = !controller.isEmailSelected.value;
                          return GestureDetector(
                            onTap: () => controller.toggleLoginMethod(false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isPhone
                                    ? const Color(0xFF040A18)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12.w),
                                border: Border.all(
                                  color: isPhone
                                      ? const Color(0xFF040A18)
                                      : const Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      color: isPhone
                                          ? Colors.white
                                          : const Color(0xFF1D1B20),
                                      size: 18.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      AppLocalizations.of(context)!.phone,
                                      style: getTextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isPhone
                                            ? Colors.white
                                            : const Color(0xFF1D1B20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Dynamic Input Form
                Obx(() {
                  if (controller.isEmailSelected.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.emailAddress,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: controller.emailController,
                          hintText: AppLocalizations.of(context)!.enterEmail,
                          keyboardType: TextInputType.emailAddress,
                          containerColor: Colors.white,
                          containerBorderColor: const Color(0xFFE5E7EB),
                          borderRedius: 28.w,
                          validation: AppValidator.validateEmail,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.phoneNumber,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1D1B20),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomIntlPhoneField(
                          controller: controller.phoneController,
                          hintText: AppLocalizations.of(context)!.enterPhone,
                          validator: (phone) {
                            if (phone == null || phone.number.isEmpty) {
                              return AppValidator.validatePhoneNumber(null);
                            }
                            return AppValidator.validatePhoneNumber(
                              phone.completeNumber,
                            );
                          },
                        ),
                      ],
                    );
                  }
                }),
                SizedBox(height: 16.h),

                // Password
                Text(
                  AppLocalizations.of(context)!.password,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(() {
                  return CustomTextFormField(
                    controller: controller.passwordController,
                    hintText: AppLocalizations.of(context)!.enterPassword,
                    obscureText: controller.isPasswordObscured.value,
                    containerColor: Colors.white,
                    containerBorderColor: const Color(0xFFE5E7EB),
                    borderRedius: 28.w,
                    validation: AppValidator.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordObscured.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 20.w,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  );
                }),
                SizedBox(height: 16.h),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => GestureDetector(
                        onTap: controller.toggleRememberMe,
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: controller.rememberMe.value
                                      ? const Color(0xFF040A18)
                                      : const Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                                color: controller.rememberMe.value
                                    ? const Color(0xFF040A18)
                                    : Colors.white,
                              ),
                              child: controller.rememberMe.value
                                  ? Icon(
                                      Icons.check,
                                      size: 14.w,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppLocalizations.of(context)!.rememberMe,
                              style: getTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.isEmailSelected.value) {
                          Get.toNamed(AppRoute.forgetPasswordEmailScreen);
                        } else {
                          Get.toNamed(AppRoute.forgetPasswordPhoneScreen);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF040A18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Sign in button
                Obx(
                  () => controller.isLoading.value
                      ? CustomLoadingIndicator()
                      : CustomSubmitButton(
                          text: AppLocalizations.of(context)!.signIn,
                          onTap: controller.login,
                          color: const Color(0xFF040A18),
                          textColor: Colors.white,
                          borderRadius: BorderRadius.circular(28.w),
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                        ),
                ),
                SizedBox(height: 32.h),

                // Divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        AppLocalizations.of(context)!.orContinueWith,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Social Logins
                Obx(
                  () => SocialButton(
                    iconWidget: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      width: 24.w,
                      height: 24.w,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.g_mobiledata,
                        size: 32.w,
                        color: Colors.blue,
                      ),
                    ),
                    text: AppLocalizations.of(context)!.continueWithGoogle,
                    isLoading: googleAuthController.isGoogleLoading.value,
                    onPressed: () => googleAuthController.signInWithGoogle(
                      keepMeLogin: controller.rememberMe.value,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => SocialButton(
                    iconWidget: Icon(
                      Icons.apple,
                      size: 28.w,
                      color: Colors.black,
                    ),
                    text: AppLocalizations.of(context)!.continueWithApple,
                    isLoading: appleAuthController.isAppleLoading.value,
                    onPressed: () => appleAuthController.signInWithApple(
                      keepMeLogin: controller.rememberMe.value,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Guest Login Text
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.continueAsA,
                      style: getTextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4B5563),
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.guest,
                          style: getTextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF040A18),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = controller.continueAsGuest,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                // Sign Up Text
                Center(
                  child: GestureDetector(
                    onTap: controller.navigateToSignUp,
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.dontHaveAccount,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4B5563),
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.signUp,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF040A18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
