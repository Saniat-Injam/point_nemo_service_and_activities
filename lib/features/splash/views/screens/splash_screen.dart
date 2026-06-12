import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/logo_path.dart';
import 'package:point_nemo_service_and_activities/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();

    return Scaffold(
      backgroundColor: const Color(0xFF040A18),
      body: Stack(
        children: [
          // App logo centered
          Center(child: Image.asset(LogoPath.appLogo)),
          // White circular dot spinner at bottom
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: const SpinKitCircle(color: Colors.white, size: 50.0),
          ),
        ],
      ),
    );
  }
}
