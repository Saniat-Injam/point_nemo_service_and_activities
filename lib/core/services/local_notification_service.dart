import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // Private constructor for Singleton pattern
  LocalNotificationService._internal();

  //Singleton instance
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  // Factory constructor to return the singleton instance
  factory LocalNotificationService.instance() => _instance;

  // Main Plugin instance for handling notifications
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Android-specific initialization settings using app launcher icons
  final _androidInitializationSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  //iOS-specific initialization settings with Permission request
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Android notification channel configuration
  final _androidChannel = const AndroidNotificationChannel(
    'channel_id',
    'Channel name',
    description: 'Android push notification channel',
    importance: Importance.max,
  );

  // Flag to track initialization status
  bool _isFlutterLocalNotificationInitialized = false;

  // Counter for generating unique notification IDs
  int _notificationIdCounter = 0;

  /// Initializes the local notifications plugin for Android and iOS.
  Future<void> init() async {
    // Check if already initialized to prevent redundant setup
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    // Create plugin instance
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Combine platform-specific settings
    final initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings,
    );

    // Initialize plugin with settings and callback for notification taps
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap in foreground
        log('Foreground notification has been tapped: ${response.payload}');
      }, 
    );

    // Create Android notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    // Mark initialization as complete
    _isFlutterLocalNotificationInitialized = true;
  }

  /// Show a local notification with th given title, body, and payload
  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    // Android-specific notification details
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      priority: Priority.high,
    );

    // iOS-specific notification details
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();

    // Combine platform-specific details
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Display the notification
    await _flutterLocalNotificationsPlugin.show(
      id: _notificationIdCounter++,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }
}
