import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/help_support_chat_controller.dart';

// Authentication
import 'package:point_nemo_service_and_activities/features/authentication/controllers/success_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/choose_verification_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/login_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/otp_verification_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/profile_setup_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/sign_up_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/forget_password_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/reset_password_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/verification_pending_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/google_auth_controller.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/apple_auth_controller.dart';

// _Business owner flow
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/business_owner_home_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/hire_captains_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/captain_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/home/controllers/captain_booking_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/stripe_payment/controllers/stripe_payment_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/register_boat/controllers/register_boat_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/controllers/create_or_edit_service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/service/controllers/business_owner_service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/controllers/business_owner_booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/business_owner_bookings/controllers/business_owner_reject_booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/_business_owner_flow/favorite/controllers/business_owner_favorite_controller.dart';

// _Captain flow
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/controllers/booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/captain_bookings/controllers/reject_booking_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/controllers/chat_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/controllers/chat_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/home/controllers/home_controller.dart';

// Global (shared across all flows)
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/logout_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/notifications/controllers/notifications_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/nav_bar/controllers/nav_bar_controller.dart';

// Onboarding & splash
import 'package:point_nemo_service_and_activities/features/onboarding/controllers/onboarding_controller.dart';
import 'package:point_nemo_service_and_activities/features/splash/controllers/splash_controller.dart';

// Role selection
import 'package:point_nemo_service_and_activities/features/authentication/controllers/role_selection_controller.dart';

// _User flow
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/booking_review_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/refund_request_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/user_bookings_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/explore/controllers/user_explore_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/search_and_filter/controllers/boat_filter_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/user_home_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_activities_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/featured_courses_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/service_bokings/controllers/service_booking_details_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/payment_methods_controller.dart';
import 'package:point_nemo_service_and_activities/features/_user_flow/home/controllers/user_favorite_controller.dart';

// Welcome
import 'package:point_nemo_service_and_activities/features/welcome/controllers/language_selection_controller.dart';

// Localization
import 'package:point_nemo_service_and_activities/core/localization/localization_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // ── Localization ────────────────────────────────────────────────────
    Get.put<LocalizationController>(LocalizationController(), permanent: true);

    // ── Authentication ──────────────────────────────────────────────────
    Get.lazyPut<SuccessController>(() => SuccessController(), fenix: true);
    Get.lazyPut<ChooseVerificationController>(
      () => ChooseVerificationController(),
      fenix: true,
    );
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(),
      fenix: true,
    );
    Get.lazyPut<ProfileSetupController>(
      () => ProfileSetupController(),
      fenix: true,
    );
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
      fenix: true,
    );
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
      fenix: true,
    );
    Get.lazyPut<VerificationPendingController>(
      () => VerificationPendingController(),
      fenix: true,
    );
    Get.lazyPut<GoogleAuthController>(() => GoogleAuthController(), fenix: true);
    Get.lazyPut<AppleAuthController>(() => AppleAuthController(), fenix: true);

    // ── _Business owner flow ─────────────────────────────────────────────
    Get.lazyPut<BusinessOwnerHomeController>(
      () => BusinessOwnerHomeController(),
      fenix: true,
    );
    Get.lazyPut<HireCaptainsController>(
      () => HireCaptainsController(),
      fenix: true,
    );
    Get.lazyPut<CaptainDetailsController>(
      () => CaptainDetailsController(),
      fenix: true,
    );
    Get.lazyPut<CaptainBookingDetailsController>(
      () => CaptainBookingDetailsController(),
      fenix: true,
    );
    Get.lazyPut<StripePaymentController>(
      () => StripePaymentController(),
      fenix: true,
    );
    Get.lazyPut<RegisterBoatController>(
      () => RegisterBoatController(),
      fenix: true,
    );
    Get.lazyPut<CreateServiceController>(
      () => CreateServiceController(),
      fenix: true,
    );
    Get.lazyPut<BusinessOwnerServiceController>(
      () => BusinessOwnerServiceController(),
      fenix: true,
    );
    Get.lazyPut<BusinessOwnerBookingController>(
      () => BusinessOwnerBookingController(),
      fenix: true,
    );
    Get.lazyPut<BusinessOwnerRejectBookingController>(
      () => BusinessOwnerRejectBookingController(),
      fenix: true,
    );
    Get.lazyPut<BusinessOwnerFavoriteController>(
      () => BusinessOwnerFavoriteController(),
      fenix: true,
    );

    // ── _Captain flow ────────────────────────────────────────────────────
    Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
    Get.lazyPut<RejectBookingController>(
      () => RejectBookingController(),
      fenix: true,
    );
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<ChatDetailsController>(
      () => ChatDetailsController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<HelpSupportChatController>(
      () => HelpSupportChatController(),
      fenix: true,
    );
    Get.lazyPut<CommonProfileController>(
      () => CommonProfileController(),
      fenix: true,
    );

    // ── Global / Shared ─────────────────────────────────────────────────
    Get.lazyPut<LogoutController>(() => LogoutController(), fenix: true);
    Get.lazyPut<CommonProfileController>(
      () => CommonProfileController(),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );
    Get.lazyPut<NavBarController>(
      () => NavBarController(),
      fenix: true,
    );

    // ── Onboarding & Splash ─────────────────────────────────────────────
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);

    // ── Role Selection ──────────────────────────────────────────────────
    Get.lazyPut<RoleSelectionController>(
      () => RoleSelectionController(),
      fenix: true,
    );

    // ── _User flow ───────────────────────────────────────────────────────
    Get.lazyPut<BookingReviewController>(
      () => BookingReviewController(),
      fenix: true,
    );
    Get.lazyPut<RefundRequestController>(
      () => RefundRequestController(),
      fenix: true,
    );
    Get.lazyPut<UserBookingsController>(
      () => UserBookingsController(),
      fenix: true,
    );
    Get.lazyPut<ServiceBookingDetailsController>(
      () => ServiceBookingDetailsController(),
      fenix: true,
    );
    Get.lazyPut<UserExploreController>(
      () => UserExploreController(),
      fenix: true,
    );
    Get.lazyPut<BoatFilterController>(
      () => BoatFilterController(),
      fenix: true,
    );
    Get.lazyPut<UserHomeController>(() => UserHomeController(), fenix: true);
    Get.lazyPut<FeaturedActivitiesController>(
      () => FeaturedActivitiesController(),
      fenix: true,
    );
    Get.lazyPut<FeaturedCoursesController>(
      () => FeaturedCoursesController(),
      fenix: true,
    );
    Get.lazyPut<ServiceDetailsController>(
      () => ServiceDetailsController(),
      fenix: true,
    );
    Get.lazyPut<ServiceController>(
      () => ServiceController(),
      fenix: true,
    );
    Get.lazyPut<PaymentMethodsController>(
      () => PaymentMethodsController(),
      fenix: true,
    );
    Get.lazyPut<UserFavoriteController>(
      () => UserFavoriteController(),
      fenix: true,
    );

    // ── Welcome ─────────────────────────────────────────────────────────
    Get.lazyPut<LanguageSelectionController>(
      () => LanguageSelectionController(),
      fenix: true,
    );
  }
}
