class AppUrls {
  AppUrls._();

  // Base Url
  static const String _baseUrl = 'http://206.162.244.142:5017/api/v1';

  // Auth Urls
  static const String login = '$_baseUrl/auth/login';
  static const String signup = '$_baseUrl/auth/signup';
  static const String verifyOtp = '$_baseUrl/auth/verify-otp';
  static const String resendOtp = '$_baseUrl/auth/resend-otp';
  static const String refreshToken = '$_baseUrl/auth/refresh-token';
  static const String getMe = '$_baseUrl/auth/me'; // For both home and profile
  static const String updateUser =
      '$_baseUrl/users/update-user'; // Also for edit profile
  static const String logout = '$_baseUrl/auth/logout';
  static const String forgotPassword = '$_baseUrl/auth/forgot-password';
  static const String changePassword = '$_baseUrl/auth/change-password';
  static const String socialSignupLogin = '$_baseUrl/auth/social-signup-login';

  // Service Urls
  static const String getAllServices = '$_baseUrl/service';
  static const String getBoatRentals = '$_baseUrl/service/boat-rentals';
  static const String getDivingCourses = '$_baseUrl/service/diving-courses';
  static const String getAllActivities = '$_baseUrl/service/activities';
  static String getServiceById(String id) => '$_baseUrl/service/$id';
  static String getServiceReviews(String id, int page, int limit) =>
      '$_baseUrl/reviews/service/$id?page=$page&limit=$limit';
  static String toggleFavorite(String id) => '$_baseUrl/favorite/$id';
  static String getUserFavorites(int page, int limit) =>
      '$_baseUrl/favorite/me?page=$page&limit=$limit';
  static String toggleCaptainFavorite(String id) =>
      '$_baseUrl/favorite/captain/$id';
  static String getCaptainFavorites(int page, int limit) =>
      '$_baseUrl/favorite/captain/me?page=$page&limit=$limit';

  // Captain Urls
  static const String getAvailableCaptains = '$_baseUrl/captains/available';
  static const String captainDashboard = '$_baseUrl/captains/dashboard';
  static String getCaptainReviews(String id, int page, int limit) =>
      '$_baseUrl/captain-reviews/captain/$id?page=$page&limit=$limit';
  static const String captainHiresFilter = '$_baseUrl/captains/hires-filter';
  static const String hireCaptain = '$_baseUrl/captains/hire';

  // Booking Urls
  static const String createBooking = '$_baseUrl/bookings';
  static const String getUserBookings = '$_baseUrl/bookings/me';
  static const String ownerDashboard = '$_baseUrl/bookings/dashboard/owner';
  static const String ownerBookings = '$_baseUrl/bookings/owner';
  static const String deleteAccount = '$_baseUrl/users/delete-user';

  // Chat Urls
  static const String getConversations =
      '$_baseUrl/chat/conversations?page=1&limit=10';
  static String getConversationMessages(String conversationId) =>
      '$_baseUrl/chat/conversations/$conversationId/messages';

  // Notification Urls
  static String getNotifications(int page, int limit) =>
      '$_baseUrl/notifications?page=$page&limit=$limit';

  static String acceptBooking(String bookingId) =>
      '$_baseUrl/bookings/$bookingId/accept';
  static String rejectBooking(String bookingId) =>
      '$_baseUrl/bookings/$bookingId/reject';
  static String cancelBooking(String bookingId) =>
      '$_baseUrl/bookings/$bookingId';

  static String approveBooking(String hireId) =>
      '$_baseUrl/captains/hire/$hireId/respond';
}
