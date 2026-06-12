import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/helpers/app_helper.dart';
import 'package:point_nemo_service_and_activities/features/.common/nav_bar/controllers/nav_bar_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/common_profile_controller.dart';
import 'package:point_nemo_service_and_activities/features/_captain_flow/home/models/captain_dashboard_model.dart';

class HomeController extends GetxController {
  final _networkCaller = NetworkCaller();

  final userRole = 'Captain'.obs;

  String get userName {
    if (Get.isRegistered<CommonProfileController>()) {
      final name = Get.find<CommonProfileController>().userName.value;
      return name.isEmpty ? 'Captain' : name;
    }
    return 'Captain';
  }

  String get userImage {
    if (Get.isRegistered<CommonProfileController>()) {
      return Get.find<CommonProfileController>().userProfileImage.value;
    }
    return '';
  }

  String get userLocalImage {
    if (Get.isRegistered<CommonProfileController>()) {
      return Get.find<CommonProfileController>().savedProfileImagePath.value;
    }
    return '';
  }

  final userStatus = 'Active'.obs;
  final totalEarnings = '\$0'.obs;
  final rawTotalEarnings = 0.obs;
  final activeCount = 0.obs;
  final pendingCount = 0.obs;

  final recentActivities = <DashboardActivity>[].obs;
  final performance = <DashboardPerformance>[].obs;
  final isLoading = false.obs;

  List<double> get thisWeekPerformance {
    if (performance.isEmpty) return [0.6, 0.75, 0.5, 0.85, 0.95, 0.4, 0.3];
    final thisWeek = performance.length >= 7 
        ? performance.sublist(performance.length - 7) 
        : performance;
    final maxCount = performance.fold<int>(1, (prev, e) => e.count > prev ? e.count : prev); 
    
    final result = thisWeek.map((e) => e.count / maxCount).toList();
    while (result.length < 7) {
      result.insert(0, 0.0);
    }
    return result;
  }

  List<double> get lastWeekPerformance {
    if (performance.length <= 7) return [0.1, 0.15, 0.2, 0.12, 0.14, 0.1, 0.18];
    int startIdx = performance.length >= 14 ? performance.length - 14 : 0;
    int endIdx = performance.length - 7;
    final lastWeek = performance.sublist(startIdx, endIdx);
    
    final maxCount = performance.fold<int>(1, (prev, e) => e.count > prev ? e.count : prev);
    final result = lastWeek.map((e) => e.count / maxCount).toList();
    while (result.length < 7) {
      result.insert(0, 0.0);
    }
    return result;
  }

  // Verification Pending Logic
  final isVerificationPending = false.obs;
  final submissionDate = 'April 24, 2025'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    // Only show verification pending if coming from profile setup
    try {
      final navController = Get.find<NavBarController>();
      if (navController.showVerificationPending.value) {
        isVerificationPending.value = true;
        Future.delayed(const Duration(seconds: 5), () {
          isVerificationPending.value = false;
          navController.showVerificationPending.value = false;
        });
      }
    } catch (_) {}
  }

  void onSupportPressed() {
    // Handle support
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    final response = await _networkCaller.getRequest(AppUrls.captainDashboard);

    if (response.isSuccess) {
      final dashboardData = CaptainDashboardModel.fromJson(response.responseData['data'] ?? {});
      
      rawTotalEarnings.value = dashboardData.totalEarnings;
      totalEarnings.value = '\$${_formatEarnings(dashboardData.totalEarnings)}';
      activeCount.value = dashboardData.activeCount;
      pendingCount.value = dashboardData.pendingCount;
      
      recentActivities.assignAll(dashboardData.recentActivity);
      performance.assignAll(dashboardData.performance);
    } else {
      AppHelperFunctions.showSnackBar(response.errorMessage);
    }

    isLoading.value = false;
  }

  String _formatEarnings(int amount) {
    if (amount >= 1000) {
      double value = amount / 1000.0;
      String formatted = value.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      return '${formatted}k';
    }
    return amount.toString();
  }
}
