import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/features/.common/notifications/controllers/notifications_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/notifications/models/notification_model.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationsController controller = Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.notificationsText,
          style: getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CustomLoadingIndicator());
          }

          final groupedData = controller.groupedNotifications;

          if (groupedData.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noNotifications,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoading &&
                  !controller.isPaginating &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                controller.fetchNotifications(isLoadMore: true);
              }
              return false;
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              itemCount: groupedData.length + (controller.isPaginating ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == groupedData.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomLoadingIndicator(),
                    ),
                  );
                }

                String dateKey = groupedData.keys.elementAt(index);
                List<NotificationModel> notifications = groupedData[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateKey,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ...notifications.map(
                      (notification) => _buildNotificationCard(notification),
                    ),
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    Color iconBackgroundColor;
    IconData iconData;
    Color iconColor = Colors.white;

    switch (notification.type) {
      case NotificationType.general:
        iconBackgroundColor = const Color(0xFF64748B);
        iconData = Icons.notifications;
        break;
      case NotificationType.bookingUpdate:
        iconBackgroundColor = const Color(0xFF8B5CF6); // Purple for booking
        iconData = Icons.book_online;
        break;
      case NotificationType.message:
        iconBackgroundColor = const Color(0xFF3B82F6); // Blue for message
        iconData = Icons.chat_bubble;
        break;
      case NotificationType.groupMessage:
        iconBackgroundColor = const Color(
          0xFF10B981,
        ); // Emerald green for group
        iconData = Icons.group;
        break;
      case NotificationType.systemAlert:
        iconBackgroundColor = const Color(0xFFEF4444); // Red for alert
        iconData = Icons.warning;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.description,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
