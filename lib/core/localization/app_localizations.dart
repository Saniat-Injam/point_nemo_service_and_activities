import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Point Nemo'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @personalizeExp.
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalize your experience'**
  String get personalizeExp;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmail;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueAsA.
  ///
  /// In en, this message translates to:
  /// **'Continue as a '**
  String get continueAsA;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @chooseVerificationMode.
  ///
  /// In en, this message translates to:
  /// **'Choose Verification\nMode'**
  String get chooseVerificationMode;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @forgotPasswordEmailSub.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you an OTP to reset your password.'**
  String get forgotPasswordEmailSub;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @forgotPasswordPhoneSub.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send you an OTP to reset your password.'**
  String get forgotPasswordPhoneSub;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code? '**
  String get didntReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @selectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Image'**
  String get selectProfileImage;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write here..'**
  String get writeHere;

  /// No description provided for @uploadNid.
  ///
  /// In en, this message translates to:
  /// **'Upload NID'**
  String get uploadNid;

  /// No description provided for @uploadYourNid.
  ///
  /// In en, this message translates to:
  /// **'Upload your NID'**
  String get uploadYourNid;

  /// No description provided for @uploadDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload the front side of your document\nSupports: JPG, PNG, PDF'**
  String get uploadDocumentSubtitle;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @uploadYourDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload your Documents'**
  String get uploadYourDocuments;

  /// No description provided for @filesSelected.
  ///
  /// In en, this message translates to:
  /// **'files selected'**
  String get filesSelected;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @successResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Successfully Reset Your\nPassword'**
  String get successResetPassword;

  /// No description provided for @successCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Successfully Create Your\nAccount'**
  String get successCreateAccount;

  /// No description provided for @goToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Go to sign in'**
  String get goToSignIn;

  /// No description provided for @continueProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Continue Profile Setup'**
  String get continueProfileSetup;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @chooseYourRole.
  ///
  /// In en, this message translates to:
  /// **'Choose your Role'**
  String get chooseYourRole;

  /// No description provided for @chooseHowToUse.
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'d like to use AquaVenture'**
  String get chooseHowToUse;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userRole;

  /// No description provided for @businessOwnerRole.
  ///
  /// In en, this message translates to:
  /// **'Business owner'**
  String get businessOwnerRole;

  /// No description provided for @captainRole.
  ///
  /// In en, this message translates to:
  /// **'Captain'**
  String get captainRole;

  /// No description provided for @exploreAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Explore events, browse cars, and preview\ncommunity highlights without signing up. '**
  String get exploreAsGuest;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @bookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get bookingRequests;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// No description provided for @rejectedBooking.
  ///
  /// In en, this message translates to:
  /// **'Rejected Booking'**
  String get rejectedBooking;

  /// No description provided for @rejectText.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectText;

  /// No description provided for @acceptText.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptText;

  /// No description provided for @completedText.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedText;

  /// No description provided for @ratedStars.
  ///
  /// In en, this message translates to:
  /// **'rated {rating} stars'**
  String ratedStars(Object rating);

  /// No description provided for @viewText.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewText;

  /// No description provided for @rejectBooking.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get rejectBooking;

  /// No description provided for @reasonForCancellation.
  ///
  /// In en, this message translates to:
  /// **'Please select the reason for cancellation:'**
  String get reasonForCancellation;

  /// No description provided for @otherReasons.
  ///
  /// In en, this message translates to:
  /// **'Other Reasons'**
  String get otherReasons;

  /// No description provided for @addReasonHere.
  ///
  /// In en, this message translates to:
  /// **'Add Reason here..'**
  String get addReasonHere;

  /// No description provided for @submitText.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitText;

  /// No description provided for @hireCaptains.
  ///
  /// In en, this message translates to:
  /// **'Hire Captains'**
  String get hireCaptains;

  /// No description provided for @professionalExperienced.
  ///
  /// In en, this message translates to:
  /// **'Professional & experienced'**
  String get professionalExperienced;

  /// No description provided for @hireText.
  ///
  /// In en, this message translates to:
  /// **'Hire'**
  String get hireText;

  /// No description provided for @activeText.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeText;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @confirmedText.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedText;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @performanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Performance Overview'**
  String get performanceOverview;

  /// No description provided for @thisWeekVsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'This week vs last week'**
  String get thisWeekVsLastWeek;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @captainBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Captain Booking Details'**
  String get captainBookingDetails;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @dateFormatHint.
  ///
  /// In en, this message translates to:
  /// **'yyyy-mm-dd'**
  String get dateFormatHint;

  /// No description provided for @boatType.
  ///
  /// In en, this message translates to:
  /// **'Boat Type'**
  String get boatType;

  /// No description provided for @selectBoatType.
  ///
  /// In en, this message translates to:
  /// **'Select boat type'**
  String get selectBoatType;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @extraFee.
  ///
  /// In en, this message translates to:
  /// **'Extra Fee'**
  String get extraFee;

  /// No description provided for @totalText.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalText;

  /// No description provided for @processingText.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processingText;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @captainDetails.
  ///
  /// In en, this message translates to:
  /// **'Captain Details'**
  String get captainDetails;

  /// No description provided for @perHour.
  ///
  /// In en, this message translates to:
  /// **'per hour'**
  String get perHour;

  /// No description provided for @hireNow.
  ///
  /// In en, this message translates to:
  /// **'Hire Now'**
  String get hireNow;

  /// No description provided for @saintMartinIsland.
  ///
  /// In en, this message translates to:
  /// **'Saint Martin Island'**
  String get saintMartinIsland;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(Object count);

  /// No description provided for @captainText.
  ///
  /// In en, this message translates to:
  /// **'Captain'**
  String get captainText;

  /// No description provided for @descriptionsText.
  ///
  /// In en, this message translates to:
  /// **'Descriptions'**
  String get descriptionsText;

  /// No description provided for @captainDescriptionSnippet.
  ///
  /// In en, this message translates to:
  /// **'Highly experienced captain with international maritime certifications... '**
  String get captainDescriptionSnippet;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @specializationsText.
  ///
  /// In en, this message translates to:
  /// **'Specializations'**
  String get specializationsText;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @registerYourBoat.
  ///
  /// In en, this message translates to:
  /// **'Register your boat'**
  String get registerYourBoat;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want\nto logout?'**
  String get logoutConfirmation;

  /// No description provided for @logOutAction.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOutAction;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @enterDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Enter date of birth'**
  String get enterDateOfBirth;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your location'**
  String get enterLocation;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @exploreActivities.
  ///
  /// In en, this message translates to:
  /// **'Explore Activities'**
  String get exploreActivities;

  /// No description provided for @featuredCourses.
  ///
  /// In en, this message translates to:
  /// **'Featured Courses'**
  String get featuredCourses;

  /// No description provided for @featuredActivities.
  ///
  /// In en, this message translates to:
  /// **'Featured Activities'**
  String get featuredActivities;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! 👋'**
  String get welcomeBack;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get noServicesFound;

  /// No description provided for @searchText.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchText;

  /// No description provided for @instantBooking.
  ///
  /// In en, this message translates to:
  /// **'Instant Booking'**
  String get instantBooking;

  /// No description provided for @fromText.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromText;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @serviceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service not found.'**
  String get serviceNotFound;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'Whats Included'**
  String get whatsIncluded;

  /// No description provided for @boatDetails.
  ///
  /// In en, this message translates to:
  /// **'Boat Details'**
  String get boatDetails;

  /// No description provided for @modelText.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelText;

  /// No description provided for @capacityText.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacityText;

  /// No description provided for @lengthText.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lengthText;

  /// No description provided for @personsText.
  ///
  /// In en, this message translates to:
  /// **'{count} persons'**
  String personsText(Object count);

  /// No description provided for @additionalService.
  ///
  /// In en, this message translates to:
  /// **'Additional Service'**
  String get additionalService;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Slots'**
  String get availableSlots;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get perDay;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @startText.
  ///
  /// In en, this message translates to:
  /// **'Start:'**
  String get startText;

  /// No description provided for @endText.
  ///
  /// In en, this message translates to:
  /// **'End:'**
  String get endText;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateAndTime;

  /// No description provided for @askYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask your question'**
  String get askYourQuestion;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @noBookingText.
  ///
  /// In en, this message translates to:
  /// **'No bookings for'**
  String get noBookingText;

  /// No description provided for @yourBookingWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Your {tab} bookings will appear here'**
  String yourBookingWillAppear(Object tab);

  /// No description provided for @cancelBookingConfirmationText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\ncancel your booking for '**
  String get cancelBookingConfirmationText;

  /// No description provided for @yesCancelText.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancelText;

  /// No description provided for @keepBookingText.
  ///
  /// In en, this message translates to:
  /// **'Keep Booking'**
  String get keepBookingText;

  /// No description provided for @wantToRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'Want to Refund your Booking?'**
  String get wantToRefundTitle;

  /// No description provided for @refundConfirmationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to Refund your booking? Please\nselect a reason so we can improve your experience.'**
  String get refundConfirmationSubtitle;

  /// No description provided for @goBackText.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBackText;

  /// No description provided for @refundRequest.
  ///
  /// In en, this message translates to:
  /// **'Refund Request'**
  String get refundRequest;

  /// No description provided for @reviewText.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewText;

  /// No description provided for @cancelText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// No description provided for @selectReasonForRefund.
  ///
  /// In en, this message translates to:
  /// **'Please select the reason for Refund'**
  String get selectReasonForRefund;

  /// No description provided for @detailsText.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsText;

  /// No description provided for @paymentsText.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsText;

  /// No description provided for @selectPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Select payment methods'**
  String get selectPaymentMethods;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get creditCard;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit card'**
  String get debitCard;

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmedTitle;

  /// No description provided for @bookingConfirmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been successfully confirmed.\nCheck your email for details.'**
  String get bookingConfirmedSubtitle;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @bookingIDText.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingIDText;

  /// No description provided for @serviceText.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceText;

  /// No description provided for @dateText.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateText;

  /// No description provided for @timeText.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeText;

  /// No description provided for @viewMyBookings.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get viewMyBookings;

  /// No description provided for @noActivitiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No activities available'**
  String get noActivitiesAvailable;

  /// No description provided for @locationNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Location not specified'**
  String get locationNotSpecified;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @viewDetailsText.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetailsText;

  /// No description provided for @noCoursesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get noCoursesAvailable;

  /// No description provided for @certifiedCourse.
  ///
  /// In en, this message translates to:
  /// **'Certified Course'**
  String get certifiedCourse;

  /// No description provided for @favoriteText.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoriteText;

  /// No description provided for @nameText.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameText;

  /// No description provided for @enterBoatName.
  ///
  /// In en, this message translates to:
  /// **'Enter your boat name'**
  String get enterBoatName;

  /// No description provided for @enterBoatModel.
  ///
  /// In en, this message translates to:
  /// **'Enter your boat model'**
  String get enterBoatModel;

  /// No description provided for @enterBoatCapacity.
  ///
  /// In en, this message translates to:
  /// **'Enter boat capacity in numbers'**
  String get enterBoatCapacity;

  /// No description provided for @boatLengthText.
  ///
  /// In en, this message translates to:
  /// **'Boat length'**
  String get boatLengthText;

  /// No description provided for @enterBoatLength.
  ///
  /// In en, this message translates to:
  /// **'Enter boat length in meter'**
  String get enterBoatLength;

  /// No description provided for @boatPriceText.
  ///
  /// In en, this message translates to:
  /// **'Boat Price'**
  String get boatPriceText;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @priceText.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceText;

  /// No description provided for @timeSlotText.
  ///
  /// In en, this message translates to:
  /// **'Time slot'**
  String get timeSlotText;

  /// No description provided for @includedServiceText.
  ///
  /// In en, this message translates to:
  /// **'Included Service'**
  String get includedServiceText;

  /// No description provided for @uploadBoatImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Boat Image'**
  String get uploadBoatImage;

  /// No description provided for @uploadBoatCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Upload your boat cover image'**
  String get uploadBoatCoverImage;

  /// No description provided for @photoText.
  ///
  /// In en, this message translates to:
  /// **'Photo {number}'**
  String photoText(Object number);

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @uploadBoatDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Boat Documents'**
  String get uploadBoatDocuments;

  /// No description provided for @saveText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveText;

  /// No description provided for @uploadServiceImage.
  ///
  /// In en, this message translates to:
  /// **'Upload {service} Image'**
  String uploadServiceImage(Object service);

  /// No description provided for @uploadYourServiceImage.
  ///
  /// In en, this message translates to:
  /// **'Upload your {service} Image'**
  String uploadYourServiceImage(Object service);

  /// No description provided for @updateServiceText.
  ///
  /// In en, this message translates to:
  /// **'Update Service'**
  String get updateServiceText;

  /// No description provided for @enterCapacityText.
  ///
  /// In en, this message translates to:
  /// **'Enter capacity (e.g. 10)'**
  String get enterCapacityText;

  /// No description provided for @enterLengthText.
  ///
  /// In en, this message translates to:
  /// **'Enter length (e.g. 50)'**
  String get enterLengthText;

  /// No description provided for @writeHereHint.
  ///
  /// In en, this message translates to:
  /// **'Write here..'**
  String get writeHereHint;

  /// No description provided for @servicesText.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesText;

  /// No description provided for @categoryText.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryText;

  /// No description provided for @myServicesText.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServicesText;

  /// No description provided for @addFirstServicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your first service using the button below'**
  String get addFirstServicePrompt;

  /// No description provided for @createServicesText.
  ///
  /// In en, this message translates to:
  /// **'Create Services'**
  String get createServicesText;

  /// No description provided for @availableText.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableText;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editText;

  /// No description provided for @boatRentalText.
  ///
  /// In en, this message translates to:
  /// **'Boat Rental'**
  String get boatRentalText;

  /// No description provided for @waterSportsText.
  ///
  /// In en, this message translates to:
  /// **'Water Sports'**
  String get waterSportsText;

  /// No description provided for @divingCourseText.
  ///
  /// In en, this message translates to:
  /// **'Diving Course'**
  String get divingCourseText;

  /// No description provided for @fishingTripText.
  ///
  /// In en, this message translates to:
  /// **'Fishing Trip'**
  String get fishingTripText;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @numberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Number of Guests'**
  String get numberOfGuests;

  /// No description provided for @noCaptainsFound.
  ///
  /// In en, this message translates to:
  /// **'No captains found'**
  String get noCaptainsFound;

  /// No description provided for @addressNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Address not provided'**
  String get addressNotProvided;

  /// No description provided for @negotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get negotiable;

  /// No description provided for @verifiedText.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedText;

  /// No description provided for @noServicesFoundDot.
  ///
  /// In en, this message translates to:
  /// **'No services found.'**
  String get noServicesFoundDot;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @unknownService.
  ///
  /// In en, this message translates to:
  /// **'Unknown Service'**
  String get unknownService;

  /// No description provided for @rejectBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get rejectBookingTitle;

  /// No description provided for @maleText.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleText;

  /// No description provided for @femaleText.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleText;

  /// No description provided for @otherText.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherText;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get navBooking;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get navService;

  /// No description provided for @messageText.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageText;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @connectingText.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connectingText;

  /// No description provided for @onlineText.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineText;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @startConversation.
  ///
  /// In en, this message translates to:
  /// **'Send a message to start the conversation'**
  String get startConversation;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get messageHint;

  /// No description provided for @notificationsText.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsText;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @refundRequestText.
  ///
  /// In en, this message translates to:
  /// **'Refund Request'**
  String get refundRequestText;

  /// No description provided for @reviewNowText.
  ///
  /// In en, this message translates to:
  /// **'Review Now'**
  String get reviewNowText;

  /// No description provided for @bookingCancelledText.
  ///
  /// In en, this message translates to:
  /// **'Booking Cancelled'**
  String get bookingCancelledText;

  /// No description provided for @upcomingText.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingText;

  /// No description provided for @seeAllText.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAllText;

  /// No description provided for @rentBoatsText.
  ///
  /// In en, this message translates to:
  /// **'Rent Boats'**
  String get rentBoatsText;

  /// No description provided for @rentBoatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Yachts, speed\nboats & more'**
  String get rentBoatsSubtitle;

  /// No description provided for @waterSportsText2.
  ///
  /// In en, this message translates to:
  /// **'Water Sports'**
  String get waterSportsText2;

  /// No description provided for @waterSportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jet ski, surfing\n& more'**
  String get waterSportsSubtitle;

  /// No description provided for @divingCoursesText.
  ///
  /// In en, this message translates to:
  /// **'Diving Courses'**
  String get divingCoursesText;

  /// No description provided for @divingCoursesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Courses and guided\nexperiences'**
  String get divingCoursesSubtitle;

  /// No description provided for @fishingTripsText.
  ///
  /// In en, this message translates to:
  /// **'Fishing Trips'**
  String get fishingTripsText;

  /// No description provided for @fishingTripsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deep sea and\ncoastal fishing'**
  String get fishingTripsSubtitle;

  /// No description provided for @serviceBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Booking Details'**
  String get serviceBookingDetails;

  /// No description provided for @skipText.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipText;

  /// No description provided for @nextText.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextText;

  /// No description provided for @divingSnorkelingText.
  ///
  /// In en, this message translates to:
  /// **'Diving & Snorkeling'**
  String get divingSnorkelingText;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose from yachts, speed boats, and sail boats\nfor your perfect water adventure'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Experience jet skiing, surfing, parasailing and\nmore exciting water activities'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore underwater worlds with professional\ncourses and guided experiences'**
  String get onboarding3Subtitle;

  /// No description provided for @onboarding4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join organized fishing expeditions with all\nequipment provided'**
  String get onboarding4Subtitle;

  /// No description provided for @onboarding5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Book experienced professional captains for your\nmaritime journey'**
  String get onboarding5Subtitle;

  /// No description provided for @allText.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allText;

  /// No description provided for @pendingText.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingText;

  /// No description provided for @acceptedText.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedText;

  /// No description provided for @filterText.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterText;

  /// No description provided for @resetText.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetText;

  /// No description provided for @allBoatRentalsText.
  ///
  /// In en, this message translates to:
  /// **'All boat rentals'**
  String get allBoatRentalsText;

  /// No description provided for @whereText.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get whereText;

  /// No description provided for @selectDatesText.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectDatesText;

  /// No description provided for @pricePerDayText.
  ///
  /// In en, this message translates to:
  /// **'Price per day'**
  String get pricePerDayText;

  /// No description provided for @minimumText.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimumText;

  /// No description provided for @maximumText.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximumText;

  /// No description provided for @numberOfPeopleText.
  ///
  /// In en, this message translates to:
  /// **'Number of people'**
  String get numberOfPeopleText;

  /// No description provided for @noBoatRentalsFound.
  ///
  /// In en, this message translates to:
  /// **'No boat rentals found for the selected filters.'**
  String get noBoatRentalsFound;

  /// No description provided for @resultsText.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsText;

  /// No description provided for @enterLocationText.
  ///
  /// In en, this message translates to:
  /// **'Enter Location'**
  String get enterLocationText;

  /// No description provided for @enterAdditionalServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your Additional services and price'**
  String get enterAdditionalServiceSubtitle;

  /// No description provided for @serviceNameText.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceNameText;

  /// No description provided for @enterServiceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter service name'**
  String get enterServiceNameHint;

  /// No description provided for @servicePriceText.
  ///
  /// In en, this message translates to:
  /// **'Service price'**
  String get servicePriceText;

  /// No description provided for @enterPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Price'**
  String get enterPriceHint;

  /// No description provided for @setServiceText.
  ///
  /// In en, this message translates to:
  /// **'Set service'**
  String get setServiceText;

  /// No description provided for @motorboatText.
  ///
  /// In en, this message translates to:
  /// **'Motorboat'**
  String get motorboatText;

  /// No description provided for @catamaranText.
  ///
  /// In en, this message translates to:
  /// **'Catamaran'**
  String get catamaranText;

  /// No description provided for @ribText.
  ///
  /// In en, this message translates to:
  /// **'RIB'**
  String get ribText;

  /// No description provided for @jetSkiText.
  ///
  /// In en, this message translates to:
  /// **'Jet Ski'**
  String get jetSkiText;

  /// No description provided for @guletText.
  ///
  /// In en, this message translates to:
  /// **'Gulet'**
  String get guletText;

  /// No description provided for @houseboatText.
  ///
  /// In en, this message translates to:
  /// **'Houseboat'**
  String get houseboatText;

  /// No description provided for @yachtOperationsText.
  ///
  /// In en, this message translates to:
  /// **'Yacht Operations'**
  String get yachtOperationsText;

  /// No description provided for @deepSeaNavigationText.
  ///
  /// In en, this message translates to:
  /// **'Deep Sea Navigation'**
  String get deepSeaNavigationText;

  /// No description provided for @safetyExpertText.
  ///
  /// In en, this message translates to:
  /// **'Safety Expert'**
  String get safetyExpertText;

  /// No description provided for @firstAidCertifiedText.
  ///
  /// In en, this message translates to:
  /// **'First Aid Certified'**
  String get firstAidCertifiedText;

  /// No description provided for @ownerText.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerText;

  /// No description provided for @noDescriptionAvailableText.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescriptionAvailableText;

  /// No description provided for @airConditioningText.
  ///
  /// In en, this message translates to:
  /// **'Air Conditioning'**
  String get airConditioningText;

  /// No description provided for @bathroomText.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get bathroomText;

  /// No description provided for @sunDeckText.
  ///
  /// In en, this message translates to:
  /// **'Sun Deck'**
  String get sunDeckText;

  /// No description provided for @kitchenText.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchenText;

  /// No description provided for @soundSystemText.
  ///
  /// In en, this message translates to:
  /// **'Sound System'**
  String get soundSystemText;

  /// No description provided for @reviewsText.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsText;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @noServiceReviews.
  ///
  /// In en, this message translates to:
  /// **'There are currently no reviews for this service.\nCheck back later!'**
  String get noServiceReviews;

  /// No description provided for @noCaptainReviews.
  ///
  /// In en, this message translates to:
  /// **'There are currently no reviews for this captain.\nCheck back later!'**
  String get noCaptainReviews;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(String count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String monthsAgo(String count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(String count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(String count);

  /// No description provided for @minsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} mins ago'**
  String minsAgo(String count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
