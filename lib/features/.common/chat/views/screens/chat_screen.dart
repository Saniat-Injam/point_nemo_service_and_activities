import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_loading_indicator.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/routes/app_routes.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/controllers/chat_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/chat_model.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: const Color(0xFF040A18),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // Header
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.messageText,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            // Chats List Background
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  ),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const CustomLoadingIndicator();
                  }
                  if (controller.chats.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: AppLocalizations.of(context)!.noMessages,
                        textColor: const Color(0xFF6B7280),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 24.h, bottom: 20.h),
                    itemCount: controller.chats.length,
                    itemBuilder: (ctx, index) {
                      return _buildChatTile(controller.chats[index]);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile(ChatModel chat) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoute.chatDetailsScreen, arguments: chat);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: chat.avatarUrl != null && chat.avatarUrl!.isNotEmpty
                      ? NetworkImage(chat.avatarUrl!) as ImageProvider
                      : AssetImage(chat.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Name and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),
                  CustomText(
                    text: chat.name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    textColor: const Color(0xFF111111),
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: chat.lastMessage,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    textColor: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
            // Time and Notification Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),
                CustomText(
                  text: chat.time,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  textColor: const Color(0xFF6B7280),
                ),
                SizedBox(height: 6.h),
                if (chat.unreadCount > 0)
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5ED545), // Green color from design
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomText(
                        text: chat.unreadCount.toString(),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.white,
                      ),
                    ),
                  )
                else
                  SizedBox(height: 22.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
