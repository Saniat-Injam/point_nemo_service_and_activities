import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:point_nemo_service_and_activities/app.dart';
import 'package:point_nemo_service_and_activities/core/services/firebase_messaging_services.dart';
import 'package:point_nemo_service_and_activities/core/services/local_notification_service.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/loggerformain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables
  await dotenv.load(
    fileName: '.env',
  ); // Must need to initialize before Firebase

  await StorageService.init();

  // Firebase Initialization
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /// Initialize Local Notification Service
  final localNotificationService = LocalNotificationService.instance();
  await localNotificationService.init();

  /// Initialize Firebase Messaging Service
  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(
    localNotificationService: localNotificationService,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    value,
  ) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(const MyApp());
  });
}
