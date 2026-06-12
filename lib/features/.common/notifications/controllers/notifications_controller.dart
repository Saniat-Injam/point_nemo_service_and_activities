import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/utils/logging/logger.dart';
import 'package:point_nemo_service_and_activities/features/.common/notifications/models/notification_model.dart';

class NotificationsController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  List<NotificationModel> _notifications = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  int limit = 10;
  bool isPaginating = false;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (currentPage >= totalPages) return;
      isPaginating = true;
      currentPage++;
    } else {
      isLoading = true;
      currentPage = 1;
      _notifications.clear();
    }
    update();

    try {
      final endpoint = AppUrls.getNotifications(currentPage, limit);
      final response = await _networkCaller.getRequest(endpoint);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        if (data != null) {
          final List listData = data['data'] ?? [];
          final meta = data['meta'];

          if (meta != null) {
            totalPages = meta['totalPage'] ?? 1;
          }

          final newNotifications = listData
              .map((json) => NotificationModel.fromJson(json))
              .toList();

          if (isLoadMore) {
            _notifications.addAll(newNotifications);
          } else {
            _notifications = newNotifications;
          }
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      AppLoggerHelper.error("Error fetching notifications: $e");
    } finally {
      isLoading = false;
      isPaginating = false;
      update();
    }
  }

  // Group by date logic
  Map<String, List<NotificationModel>> get groupedNotifications {
    Map<String, List<NotificationModel>> grouped = {};

    for (var notification in _notifications) {
      String dateKey = _formatDateKey(notification.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today, ${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } else if (notificationDate == yesterday) {
      return 'Yesterday, ${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } else {
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
