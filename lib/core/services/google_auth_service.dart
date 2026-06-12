import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/role_selection_controller.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

/// Centralised Google authentication service used by both Login and SignUp screens.
class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static final NetworkCaller _networkCaller = NetworkCaller();

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────

  /// Triggers the native Google sign-in flow and sends the user data
  /// to the backend social-signup-login endpoint.
  ///
  /// [keepMeLogin]  – mirrors the "Remember Me" toggle on the calling screen.
  /// [role]         – only provided when called from the sign-up / role-selection
  ///                  part of the flow. Omit for the regular login tap.
  ///
  /// Returns `true` when the user is successfully authenticated and navigated;
  /// `false` otherwise.
  static Future<bool> signInWithGoogle({
    bool keepMeLogin = false,
    String? role,
  }) async {
    try {
      // 1. Force account picker every time
      await _googleSignIn.signOut();

      // 2. Launch Google account picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false; // User cancelled

      // 3. Build the request body (new API shape)
      final Map<String, dynamic> body = {
        'email': googleUser.email,
        'logInProcess': 'GOOGLE',
        'fcmToken': 'device-token-here',
      };
      
      if (googleUser.displayName != null && googleUser.displayName!.isNotEmpty) {
        body['fullName'] = googleUser.displayName;
      }
      if (googleUser.photoUrl != null && googleUser.photoUrl!.isNotEmpty) {
        body['profileImage'] = googleUser.photoUrl;
      }

      if (role != null && role.isNotEmpty) {
        body['role'] = role;
      }

      // 4. Call backend
      final response = await _networkCaller.postRequest(
        AppUrls.socialSignupLogin,
        body: body,
      );

      if (response.isSuccess) {
        log('Google Auth Response: ${response.responseData}');
        return await _handleSuccessResponse(
          responseData: response.responseData,
          googleEmail: googleUser.email,
          role: role,
          googleName: googleUser.displayName,
          googlePhotoUrl: googleUser.photoUrl,
          keepMeLogin: keepMeLogin,
        );
      }

      // ── Error path ────────────────────────────────────────────────────────
      final serverMessage = _extractMessage(response);
      final lowerMsg = serverMessage.toLowerCase();
      final isUserNotFound =
          lowerMsg.contains('not found') ||
          lowerMsg.contains('no user') ||
          lowerMsg.contains('does not exist') ||
          lowerMsg.contains('role') ||
          response.statusCode == 404;

      // Login flow (no role) + user doesn't exist → go to Role Selection
      if (role == null && isUserNotFound) {
        log('Google Auth: New user detected — redirecting to Role Selection');

        // Delete the controller so onInit() re-runs with fresh Google arguments.
        // Without this, a previously created controller keeps fromGoogle=false.
        if (Get.isRegistered<RoleSelectionController>()) {
          Get.delete<RoleSelectionController>();
        }

        Get.toNamed(
          AppRoute.roleSelectionScreen,
          arguments: {
            'fromGoogle': true,
            'googleEmail': googleUser.email,
            'googleName': googleUser.displayName,
            'googlePhotoUrl': googleUser.photoUrl,
            'keepMeLogin': keepMeLogin,
          },
        );
        return false; // navigation handled
      }

      AppHelperFunctions.showSnackBar(
        serverMessage.isNotEmpty
            ? serverMessage
            : 'Google sign-in failed. Please try again.',
      );
    } catch (e) {
      log('GoogleAuthService Error: $e');
      debugPrint('Google Sign-In Error: $e');
      AppHelperFunctions.showSnackBar(
        'Google sign-in failed. Please try again.',
      );
    }

    return false;
  }

  /// Called by [RoleSelectionController] after the user picks a role in the
  /// Google new-user sign-up flow.
  static Future<bool> completeGoogleSignUp({
    required String googleEmail,
    required String role,
    String? fullName,
    String? profileImage,
    bool keepMeLogin = false,
  }) async {
    final Map<String, dynamic> body = {
      'email': googleEmail,
      'logInProcess': 'GOOGLE',
      'fcmToken': 'device-token-here',
      'role': role,
    };
    if (fullName != null && fullName.isNotEmpty) {
      body['fullName'] = fullName;
    }
    if (profileImage != null && profileImage.isNotEmpty) {
      body['profileImage'] = profileImage;
    }

    final response = await _networkCaller.postRequest(
      AppUrls.socialSignupLogin,
      body: body,
    );

    if (response.isSuccess) {
      log('Google Sign-Up Complete Response: ${response.responseData}');
      return await _handleSuccessResponse(
        responseData: response.responseData,
        googleEmail: googleEmail,
        role: role,
        googleName: fullName,
        googlePhotoUrl: profileImage,
        keepMeLogin: keepMeLogin,
      );
    }

    final serverMessage = _extractMessage(response);
    AppHelperFunctions.showSnackBar(
      serverMessage.isNotEmpty
          ? serverMessage
          : 'Google sign-up failed. Please try again.',
    );
    return false;
  }

  /// Signs the user out of the Google session (useful during logout).
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      log('Google Sign-Out Error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  /// Parses the success response, persists tokens, and navigates.
  static Future<bool> _handleSuccessResponse({
    required dynamic responseData,
    required String googleEmail,
    String? role,
    String? googleName,
    String? googlePhotoUrl,
    bool keepMeLogin = false,
  }) async {
    // Support both { data: {...} } and flat { accessToken: ... } shapes
    final data =
        (responseData is Map && responseData.containsKey('data'))
            ? responseData['data'] as Map?
            : responseData as Map?;

    if (data == null) {
      AppHelperFunctions.showSnackBar(
        'Google sign-in failed: unexpected server response.',
      );
      return false;
    }

    final String? accessToken = data['accessToken']?.toString();
    final String? refreshToken = data['refreshToken']?.toString();
    final String? userId =
        (data['user'] is Map)
            ? data['user']['id']?.toString()
            : data['id']?.toString();

    final String? apiRole =
        data['role']?.toString() ?? data['user']?['role']?.toString();

    // Prefer the role explicitly chosen by the user; fallback to API role
    final String resolvedRole =
        (role?.isNotEmpty == true ? role! : (apiRole ?? 'USER')).toUpperCase();

    log('Google Auth: chosen=$role  api=$apiRole  resolved=$resolvedRole');

    if (accessToken == null || userId == null) {
      log('Google Auth: missing accessToken or userId. data=$data');
      AppHelperFunctions.showSnackBar(
        'Google sign-in failed: incomplete server response.',
      );
      return false;
    }

    // Persist tokens
    await StorageService.saveToken(
      token: accessToken,
      refreshToken: refreshToken,
      id: userId,
      role: resolvedRole,
    );

    // Persist Remember Me state
    await StorageService.saveRememberMe(
      rememberMe: keepMeLogin,
      identifier: googleEmail,
      loginMethod: 'google',
      password: '',
    );

    // Save initial profile details for instant display
    final String? apiName = data['fullName']?.toString() ?? (data['user'] is Map ? data['user']['fullName']?.toString() : null);
    final String? apiImage = data['profileImage']?.toString() ?? (data['user'] is Map ? data['user']['profileImage']?.toString() : null);

    final finalName = apiName?.isNotEmpty == true ? apiName! : (googleName ?? '');
    final finalImage = apiImage?.isNotEmpty == true ? apiImage! : (googlePhotoUrl ?? '');

    if (finalName.isNotEmpty || finalImage.isNotEmpty) {
      await StorageService.saveProfileCache(imageUrl: finalImage, name: finalName);
    }

    // Navigate: new user (role provided) → profile setup
    //           existing user (login)    → home
    if (role != null && role.isNotEmpty) {
      Get.offAllNamed(
        AppRoute.profileSetupScreen,
        arguments: {'role': resolvedRole, 'isGuest': false},
      );
    } else {
      Get.offAllNamed(
        AppRoute.mainBottomNavBar,
        arguments: {'role': resolvedRole, 'isGuest': false},
      );
    }

    return true;
  }

  /// Extracts a human-readable error message from a [ResponseData].
  static String _extractMessage(dynamic response) {
    try {
      if (response.responseData is Map) {
        return response.responseData['message']?.toString() ??
            response.responseData['error']?.toString() ??
            response.errorMessage ??
            '';
      }
    } catch (_) {}
    return response.errorMessage ?? '';
  }
}
