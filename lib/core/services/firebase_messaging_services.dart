import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:point_nemo_service_and_activities/core/services/local_notification_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance =
  FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationService? _localNotificationService;

  /// Initialize Firebase Messaging and sets up all message Listeners
  Future<void> init({
    required LocalNotificationService localNotificationService,
  }) async {
    // Init local notifications service
    _localNotificationService = localNotificationService;

    // Handle FCM Token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for message when app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  /// Retrieves and manages the FCM Token for Push Notification
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM Token for the device
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('Push Notification Token: $token');

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      debugPrint('FCM Token refreshed: $fcmToken');
      // TODO: optionally send token to your server for targeting this devicee
    }).onError((error) {
      // Handle errors during token refresh
      debugPrint('Error refreshing FCM Token: $error');
    });
  }

  /// Request notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true
    );

    // Log the user's permission decision
    debugPrint('User granted permission: ${result.authorizationStatus}');
    if(result.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('User denied notification permissions');
    }
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      _localNotificationService?.showNotification(
          notificationData.title, notificationData.body, message.data.toString());
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.data.toString()}');
}
