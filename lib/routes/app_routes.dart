import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/.common/nav_bar/views/screens/nav_bar.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/screens/captain_booking_details_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/views/screens/hire_captains_screen.dart';
import 'package:point_nemo_service_and_activities/features/stripe_payment/views/screens/stripe_payment_screen.dart';

import 'package:point_nemo_service_and_activities/features/authentication/views/screens/login_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/sign_up_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/success_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/choose_verification_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/otp_verification_screen.dart';
import 'package:point_nemo_service_and_activities/features/onboarding/views/screens/onboarding_screen.dart';
import 'package:point_nemo_service_and_activities/features/splash/views/screens/splash_screen.dart';
import 'package:point_nemo_service_and_activities/features/welcome/views/screens/language_selection_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/role_selection_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/profile_setup_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/forget_password_email_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/forget_password_phone_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/reset_password_screen.dart';
import 'package:point_nemo_service_and_activities/features/authentication/views/screens/verification_pending_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/views/screens/chat_details_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/screens/edit_profile_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/screens/change_password_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/screens/language_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/screens/help_support_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/views/screens/user_home_screen.dart';
import 'package:point_nemo_service_and_activities/features/.common/notifications/views/screens/notifications_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/booking_review_screen.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/views/screens/refund_request_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/register_boat/views/screens/register_boat_screen.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/favorite/views/screens/business_owner_favorite_screen.dart';

class AppRoute {
  static String init = "/";
  static String languageSelectionScreen = "/languageSelectionScreen";
  static String onboardingScreen = "/onboardingScreen";
  static String roleSelectionScreen = "/roleSelectionScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String successScreen = "/successScreen";
  static String chooseVerificationScreen = "/chooseVerificationScreen";
  static String otpVerificationScreen = "/otpVerificationScreen";
  static String profileSetupScreen = "/profileSetupScreen";
  static String forgetPasswordEmailScreen = "/forgetPasswordEmailScreen";
  static String forgetPasswordPhoneScreen = "/forgetPasswordPhoneScreen";
  static String resetPasswordScreen = "/resetPasswordScreen";
  static String verificationPendingScreen = "/verificationPendingScreen";
  static String mainBottomNavBar = "/mainBottomNavBar";
  static String chatDetailsScreen = "/chatDetailsScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String changePasswordScreen = "/changePasswordScreen";
  static String languageScreen = "/languageScreen";
  static String helpSupportScreen = "/helpSupportScreen";
  static String userHomeScreen = "/userHomeScreen";
  static String notificationsScreen = "/notificationsScreen";
  static String hireCaptainsScreen = "/hireCaptainsScreen";
  static String bookingReviewScreen = "/bookingReviewScreen";
  static String refundRequestScreen = "/refundRequestScreen";
  static String registerBoatScreen = "/registerBoatScreen";
  static String captainBookingDetailsScreen = "/captainBookingDetailsScreen";
  static String stripePaymentScreen = "/stripePaymentScreen";
  static String businessOwnerFavoriteScreen = "/businessOwnerFavoriteScreen";

  static List<GetPage> routes = [
    GetPage(name: init, page: () => const SplashScreen()),
    GetPage(
      name: languageSelectionScreen,
      page: () => const LanguageSelectionScreen(),
    ),
    GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: roleSelectionScreen, page: () => const RoleSelectionScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: successScreen, page: () => const SuccessScreen()),
    GetPage(
      name: chooseVerificationScreen,
      page: () => const ChooseVerificationScreen(),
    ),
    GetPage(
      name: otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
    ),
    GetPage(name: profileSetupScreen, page: () => const ProfileSetupScreen()),
    GetPage(
      name: forgetPasswordEmailScreen,
      page: () => const ForgetPasswordEmailScreen(),
    ),
    GetPage(
      name: forgetPasswordPhoneScreen,
      page: () => const ForgetPasswordPhoneScreen(),
    ),
    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),
    GetPage(
      name: verificationPendingScreen,
      page: () => const VerificationPendingScreen(),
    ),
    GetPage(name: mainBottomNavBar, page: () => const NavBar()),
    GetPage(name: chatDetailsScreen, page: () => const ChatDetailsScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(
      name: changePasswordScreen,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(name: languageScreen, page: () => const LanguageScreen()),
    GetPage(name: helpSupportScreen, page: () => const HelpSupportScreen()),
    GetPage(name: userHomeScreen, page: () => UserHomeScreen()),
    GetPage(name: notificationsScreen, page: () => NotificationsScreen()),
    GetPage(
      name: hireCaptainsScreen,
      page: () => const HireCaptainsScreen(),
    ),
    GetPage(name: bookingReviewScreen, page: () => const BookingReviewScreen()),
    GetPage(name: refundRequestScreen, page: () => const RefundRequestScreen()),
    GetPage(name: registerBoatScreen, page: () => const RegisterBoatScreen()),
    GetPage(
      name: captainBookingDetailsScreen,
      page: () => const CaptainBookingDetailsScreen(),
    ),
    GetPage(
      name: stripePaymentScreen,
      page: () => const StripePaymentScreen(),
    ),
    GetPage(
      name: businessOwnerFavoriteScreen,
      page: () => const BusinessOwnerFavoriteScreen(),
    ),
  ];
}
