import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_intl_phone_field.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/sign_up_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_textformfield.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_submit_button.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_appbar.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/google_auth_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/apple_auth_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/widgets/social_button.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';
import 'package:point_nemo_service_and_activities/core/utils/validators/app_validator.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>();
    final googleAuthController = Get.find<GoogleAuthController>();
    final appleAuthController = Get.find<AppleAuthController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.createAccount,
        backgroundColor: Colors.white,
        showBackIcon: true,
        centerTitle: false,
        titleColor: const Color(0xFF1D1B20),
        titleSize: 24.sp,
        titleWeight: FontWeight.w600,
        enableShadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Full Name
              Text(
                AppLocalizations.of(context)!.fullName,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: controller.fullNameController,
                hintText: AppLocalizations.of(context)!.enterName,
                keyboardType: TextInputType.name,
                containerColor: Colors.white,
                containerBorderColor: const Color(0xFFE5E7EB),
                borderRedius: 28.w,
                validation: (val) => AppValidator.validateNotEmpty(val, 'Full Name'),
              ),
              SizedBox(height: 16.h),

              // Phone Number
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
                  return AppValidator.validatePhoneNumber(phone.completeNumber);
                },
                onChanged: (phone) {
                  controller.completePhoneNumber = phone.completeNumber;
                },
              ),
              SizedBox(height: 16.h),

              // Email Address
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
              Obx(
                () => CustomTextFormField(
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
                ),
              ),
              SizedBox(height: 16.h),

              // Remember Me
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
                            ? Icon(Icons.check, size: 14.w, color: Colors.white)
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
              SizedBox(height: 32.h),

              // Sign up button
              Obx(
                () => controller.isLoading.value
                    ? const CustomLoadingIndicator()
                    : CustomSubmitButton(
                        text: AppLocalizations.of(context)!.signUp,
                        onTap: controller.signUp,
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
                    role: controller.role.value,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => SocialButton(
                  iconWidget: Icon(Icons.apple, size: 28.w, color: Colors.black),
                  text: AppLocalizations.of(context)!.continueWithApple,
                  isLoading: appleAuthController.isAppleLoading.value,
                  onPressed: () => appleAuthController.signInWithApple(
                    keepMeLogin: controller.rememberMe.value,
                    role: controller.role.value,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.08),

              // Sign In Text
              Center(
                child: GestureDetector(
                  onTap: controller.navigateToSignIn,
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.alreadyHaveAccount,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4B5563),
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.signIn,
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

