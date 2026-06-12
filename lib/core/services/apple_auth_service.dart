import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/authentication/controllers/role_selection_controller.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';

/// Centralised Apple authentication service used by both Login and SignUp screens.
/// Uses the same [AppUrls.socialSignupLogin] endpoint as Google, but with
/// `logInProcess: 'APPLE'`.
class AppleAuthService {
  AppleAuthService._();

  static final NetworkCaller _networkCaller = NetworkCaller();

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────

  /// Triggers the native Apple sign-in flow and sends the user data
  /// to the backend social-signup-login endpoint.
  ///
  /// [keepMeLogin]  – mirrors the "Remember Me" toggle on the calling screen.
  /// [role]         – only provided when called from the sign-up / role-selection
  ///                  part of the flow. Omit for the regular login tap.
  ///
  /// Returns `true` when the user is successfully authenticated and navigated;
  /// `false` otherwise.
  static Future<bool> signInWithApple({
    bool keepMeLogin = false,
    String? role,
  }) async {
    try {
      // 1. Launch Apple sign-in sheet
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.saniat.pointnemo.service',
          redirectUri: Uri.parse(
            'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
      );

      // Apple only provides email & name on FIRST sign-in.
      // On subsequent sign-ins these fields may be null.
      final String? appleEmail = credential.email;
      final String? givenName = credential.givenName;
      final String? familyName = credential.familyName;
      final String? fullName =
          (givenName != null || familyName != null)
              ? '${givenName ?? ''} ${familyName ?? ''}'.trim()
              : null;

      // identityToken is always present; use it as an identifier if email is missing.
      final String? identityToken = credential.identityToken;

      // 2. Build the request body
      final Map<String, dynamic> body = {
        'logInProcess': 'APPLE',
        'fcmToken': 'device-token-here',
      };

      if (appleEmail != null && appleEmail.isNotEmpty) {
        body['email'] = appleEmail;
      }
      if (identityToken != null && identityToken.isNotEmpty) {
        body['identityToken'] = identityToken;
      }
      if (fullName != null && fullName.isNotEmpty) {
        body['fullName'] = fullName;
      }
      if (role != null && role.isNotEmpty) {
        body['role'] = role;
      }

      // 3. Call backend
      final response = await _networkCaller.postRequest(
        AppUrls.socialSignupLogin,
        body: body,
      );

      if (response.isSuccess) {
        log('Apple Auth Response: ${response.responseData}');
        return await _handleSuccessResponse(
          responseData: response.responseData,
          appleEmail: appleEmail ?? '',
          role: role,
          appleName: fullName,
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
        log('Apple Auth: New user detected — redirecting to Role Selection');

        // Delete the controller so onInit() re-runs with fresh Apple arguments.
        if (Get.isRegistered<RoleSelectionController>()) {
          Get.delete<RoleSelectionController>();
        }

        Get.toNamed(
          AppRoute.roleSelectionScreen,
          arguments: {
            'fromApple': true,
            'appleEmail': appleEmail ?? '',
            'appleName': fullName,
            'keepMeLogin': keepMeLogin,
          },
        );
        return false; // navigation handled
      }

      AppHelperFunctions.showSnackBar(
        serverMessage.isNotEmpty
            ? serverMessage
            : 'Apple sign-in failed. Please try again.',
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        // User dismissed the sheet — silently ignore
        return false;
      }
      log('AppleAuthService Authorization Error: $e');
      AppHelperFunctions.showSnackBar('Apple sign-in failed. Please try again.');
    } catch (e) {
      log('AppleAuthService Error: $e');
      debugPrint('Apple Sign-In Error: $e');
      AppHelperFunctions.showSnackBar('Apple sign-in failed. Please try again.');
    }

    return false;
  }

  /// Called by [RoleSelectionController] after the user picks a role in the
  /// Apple new-user sign-up flow.
  static Future<bool> completeAppleSignUp({
    required String appleEmail,
    required String role,
    String? fullName,
    String? identityToken,
    bool keepMeLogin = false,
  }) async {
    final Map<String, dynamic> body = {
      'logInProcess': 'APPLE',
      'fcmToken': 'device-token-here',
      'role': role,
    };
    if (appleEmail.isNotEmpty) {
      body['email'] = appleEmail;
    }
    if (fullName != null && fullName.isNotEmpty) {
      body['fullName'] = fullName;
    }
    if (identityToken != null && identityToken.isNotEmpty) {
      body['identityToken'] = identityToken;
    }

    final response = await _networkCaller.postRequest(
      AppUrls.socialSignupLogin,
      body: body,
    );

    if (response.isSuccess) {
      log('Apple Sign-Up Complete Response: ${response.responseData}');
      return await _handleSuccessResponse(
        responseData: response.responseData,
        appleEmail: appleEmail,
        role: role,
        appleName: fullName,
        keepMeLogin: keepMeLogin,
      );
    }

    final serverMessage = _extractMessage(response);
    AppHelperFunctions.showSnackBar(
      serverMessage.isNotEmpty
          ? serverMessage
          : 'Apple sign-up failed. Please try again.',
    );
    return false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  /// Parses the success response, persists tokens, and navigates.
  static Future<bool> _handleSuccessResponse({
    required dynamic responseData,
    required String appleEmail,
    String? role,
    String? appleName,
    bool keepMeLogin = false,
  }) async {
    // Support both { data: {...} } and flat { accessToken: ... } shapes
    final data =
        (responseData is Map && responseData.containsKey('data'))
            ? responseData['data'] as Map?
            : responseData as Map?;

    if (data == null) {
      AppHelperFunctions.showSnackBar(
        'Apple sign-in failed: unexpected server response.',
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

    log('Apple Auth: chosen=$role  api=$apiRole  resolved=$resolvedRole');

    if (accessToken == null || userId == null) {
      log('Apple Auth: missing accessToken or userId. data=$data');
      AppHelperFunctions.showSnackBar(
        'Apple sign-in failed: incomplete server response.',
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
      identifier: appleEmail,
      loginMethod: 'apple',
      password: '',
    );

    // Save initial profile details for instant display (Apple has no photo)
    final String? apiName =
        data['fullName']?.toString() ??
        (data['user'] is Map ? data['user']['fullName']?.toString() : null);

    final finalName =
        apiName?.isNotEmpty == true ? apiName! : (appleName ?? '');

    if (finalName.isNotEmpty) {
      await StorageService.saveProfileCache(imageUrl: '', name: finalName);
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
