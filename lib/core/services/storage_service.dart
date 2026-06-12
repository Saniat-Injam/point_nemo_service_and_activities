// ignore_for_file: file_names

import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/features/.common/nav_bar/controllers/nav_bar_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _idKey = 'id';
  static const String _roleKey = 'role';

  // Cached profile data keys (for instant display on restart)
  static const String _profileImageUrlKey = 'profileImageUrl';
  static const String _userNameKey = 'userName';
  static const String _phoneNumberKey = 'phoneNumber';

  // Language key
  static const String _languageKey = 'language_code';

  // Remember Me keys
  static const String _rememberMeKey = 'rememberMe';
  static const String _savedIdentifierKey = 'savedIdentifier';
  static const String _savedLoginMethodKey =
      'savedLoginMethod'; // 'email' or 'phone'
  static const String _savedPasswordKey = 'savedPassword';

  // Singleton instance for SharedPreferences
  static late SharedPreferences _preferences;

  // Private variables to hold token and userId
  static String? _token;
  static String? _refreshToken;
  static String? _id;
  static String? _role;

  // Cached profile data
  static String? _profileImageUrl;
  static String? _userName;
  static String? _phoneNumber;

  // Language
  static String? _language;

  // Remember Me private variables
  static bool _rememberMe = false;
  static String? _savedIdentifier;
  static String? _savedLoginMethod;
  static String? _savedPassword;

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    // Load token and userId from SharedPreferences into private variables
    _token = _preferences.getString(_tokenKey);
    _refreshToken = _preferences.getString(_refreshTokenKey);
    _id = _preferences.getString(_idKey);
    _role = _preferences.getString(_roleKey);
    // Load cached profile data
    _profileImageUrl = _preferences.getString(_profileImageUrlKey);
    _userName = _preferences.getString(_userNameKey);
    _phoneNumber = _preferences.getString(_phoneNumberKey);
    // Load Language
    _language = _preferences.getString(_languageKey) ?? 'en';
    // Load Remember Me data
    _rememberMe = _preferences.getBool(_rememberMeKey) ?? false;
    _savedIdentifier = _preferences.getString(_savedIdentifierKey);
    _savedLoginMethod = _preferences.getString(_savedLoginMethodKey);
    _savedPassword = _preferences.getString(_savedPasswordKey);
    log(_token ?? "");
    log(_id ?? "");
  }

  // Check if a token exists in local storage
  static bool hasToken() {
    return _preferences.containsKey(_tokenKey);
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken({
    String? token,
    String? refreshToken,
    String? id,
    String? role,
  }) async {
    try {
      if (token == null || token.isEmpty) {
        log('saveToken: accessToken is null or empty — skipping save');
        return;
      }

      await _preferences.setString(_tokenKey, token);
      _token = token;

      if (id != null && id.isNotEmpty) {
        await _preferences.setString(_idKey, id);
        _id = id;
      } else {
        log('saveToken: user id is null or empty — saving token without id');
      }

      if (role != null && role.isNotEmpty) {
        log('saveToken: Saving role: $role');
        await _preferences.setString(_roleKey, role);
        _role = role;
      }

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _preferences.setString(_refreshTokenKey, refreshToken);
        _refreshToken = refreshToken;
      }
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  /// Calls the refresh-token endpoint and updates the stored access token.
  /// Returns true on success, false on failure.
  static Future<bool> refreshAccessToken() async {
    final storedRefreshToken = _refreshToken;
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      log('No refresh token available');
      return false;
    }
    try {
      final response = await http.post(
        Uri.parse(AppUrls.refreshToken),
        body: jsonEncode({'refreshToken': storedRefreshToken}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse is Map) {
          final result = decodedResponse['result'] as Map?;
          final newAccessToken = result?['accessToken'] as String?;
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await _preferences.setString(_tokenKey, newAccessToken);
            _token = newAccessToken;
            log('Access token refreshed successfully');
            return true;
          }
        }
      }
      log('Failed to refresh token: Status ${response.statusCode}');
      return false;
    } catch (e) {
      log('Error refreshing token: $e');
      return false;
    }
  }

  // ── Remember Me ─────────────────────────────────────────────────────────

  /// Persists the Remember Me preference along with the credential used to log in.
  /// [loginMethod] should be either 'email' or 'phone'.
  static Future<void> saveRememberMe({
    required bool rememberMe,
    String? identifier,
    String? loginMethod,
    String? password,
  }) async {
    _rememberMe = rememberMe;
    await _preferences.setBool(_rememberMeKey, rememberMe);

    if (rememberMe &&
        identifier != null &&
        loginMethod != null &&
        password != null) {
      _savedIdentifier = identifier;
      _savedLoginMethod = loginMethod;
      _savedPassword = password;
      await _preferences.setString(_savedIdentifierKey, identifier);
      await _preferences.setString(_savedLoginMethodKey, loginMethod);
      await _preferences.setString(_savedPasswordKey, password);
    } else if (!rememberMe) {
      // Clear saved credentials when Remember Me is turned off
      _savedIdentifier = null;
      _savedLoginMethod = null;
      _savedPassword = null;
      await _preferences.remove(_savedIdentifierKey);
      await _preferences.remove(_savedLoginMethodKey);
      await _preferences.remove(_savedPasswordKey);
    }
  }

  /// Whether auto-login should be attempted on startup.
  /// Returns true only if Remember Me is on AND a valid token is stored.
  static bool get shouldAutoLogin => _rememberMe && hasToken();

  // Clear authentication data (for logout or clearing auth data)
  static Future<void> logoutUser() async {
    try {
      String? roleToPass = _role;
      try {
        if (Get.isRegistered<NavBarController>()) {
          roleToPass ??= Get.find<NavBarController>().role;
        }
      } catch (_) {}

      // Preserve Remember Me credentials before clearing preferences
      final bool keepRememberMe = _rememberMe;
      final String? savedId = _savedIdentifier;
      final String? savedMethod = _savedLoginMethod;
      final String? savedPassword = _savedPassword;

      // Clear all data from SharedPreferences
      await _preferences.clear();

      // Reset private auth variables
      _token = null;
      _refreshToken = null;
      _id = null;
      _role = null;
      _profileImageUrl = null;
      _userName = null;
      _phoneNumber = null;

      // Restore Remember Me data if it was enabled, so login screen
      // can pre-fill the saved credential after logout.
      if (keepRememberMe &&
          savedId != null &&
          savedMethod != null &&
          savedPassword != null) {
        _rememberMe = keepRememberMe;
        _savedIdentifier = savedId;
        _savedLoginMethod = savedMethod;
        _savedPassword = savedPassword;
        await _preferences.setBool(_rememberMeKey, keepRememberMe);
        await _preferences.setString(_savedIdentifierKey, savedId);
        await _preferences.setString(_savedLoginMethodKey, savedMethod);
        await _preferences.setString(_savedPasswordKey, savedPassword);
      } else {
        _rememberMe = false;
        _savedIdentifier = null;
        _savedLoginMethod = null;
        _savedPassword = null;
      }

      if (Get.isRegistered<NavBarController>()) {
        Get.delete<NavBarController>();
      }

      // Redirect to the login screen
      await goToLogin(roleToPass);
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  // Navigate to the login screen (e.g., after logout or token expiry)
  static Future<void> goToLogin([String? previousRole]) async {
    Get.offAllNamed(
      AppRoute.loginScreen,
      arguments: {'previousRole': previousRole},
    );
  }

  // ── Cached Profile Data ──────────────────────────────────────────────────
  static Future<void> saveProfileCache({
    required String imageUrl,
    required String name,
    String? phoneNumber,
  }) async {
    _profileImageUrl = imageUrl;
    _userName = name;
    await _preferences.setString(_profileImageUrlKey, imageUrl);
    await _preferences.setString(_userNameKey, name);
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      _phoneNumber = phoneNumber;
      await _preferences.setString(_phoneNumberKey, phoneNumber);
    }
  }

  // Getters
  static String? get token => _token;
  static String? get refreshToken => _refreshToken;
  static String? get id => _id;
  static String? get role => _role;
  static String? get profileImageUrl => _profileImageUrl;
  static String? get cachedUserName => _userName;
  static String? get cachedPhoneNumber => _phoneNumber;
  static String? get language => _language;

  static Future<void> saveLanguage(String langCode) async {
    _language = langCode;
    await _preferences.setString(_languageKey, langCode);
  }

  // Remember Me getters
  static bool get rememberMe => _rememberMe;
  static String? get savedIdentifier => _savedIdentifier;
  static String? get savedLoginMethod => _savedLoginMethod;
  static String? get savedPassword => _savedPassword;
}
