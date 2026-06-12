import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_nemo_service_and_activities/core/custom/widgets/custom_text.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/message_model.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/chat_model.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/controllers/chat_details_controller.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatDetailsController>();
    final chatUser = controller.chatUser.value;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        size: 20.w,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: chatUser.avatarUrl != null &&
                              chatUser.avatarUrl!.isNotEmpty
                          ? NetworkImage(chatUser.avatarUrl!) as ImageProvider
                          : AssetImage(
                              chatUser.imagePath.isNotEmpty
                                  ? chatUser.imagePath
                                  : ImagePath.johnDoe,
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: chatUser.name,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        textColor: const Color(0xFF111111),
                      ),
                      // Connection status indicator
                      Obx(() {
                        if (controller.isJoining.value) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                                height: 10.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                text: AppLocalizations.of(context)!.connectingText,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                textColor: const Color(0xFF6B7280),
                              ),
                            ],
                          );
                        }
                        return CustomText(
                          text: AppLocalizations.of(context)!.onlineText,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          textColor: const Color(0xFF22C55E),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Center(
              child: CustomText(
                text: _todayDateLabel(),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                textColor: const Color(0xFF111111),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingHistory.value &&
                    controller.messages.isEmpty) {
                  // Skeleton loader while fetching history
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0D1B3E),
                      strokeWidth: 2.5,
                    ),
                  );
                }
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48.w,
                            color: const Color(0xFFD1D5DB),
                          ),
                          SizedBox(height: 16.h),
                          CustomText(
                            text: AppLocalizations.of(context)!.noMessagesYet,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            textColor: const Color(0xFF9CA3AF),
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: AppLocalizations.of(context)!.startConversation,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            textColor: const Color(0xFFD1D5DB),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(
                      controller.messages[index],
                      chatUser,
                    );
                  },
                );
              }),
            ),
            _buildMessageInput(context, controller),
          ],
        ),
      ),
    );
  }

  /// Returns a formatted date label for today.
  String _todayDateLabel() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';
  }

  Widget _buildMessageBubble(
    MessageModel message,
    ChatModel chatUser,
  ) {
    final firstName = chatUser.name.split(' ')[0];
    if (message.isMe) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 280.w),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFC7C1EF), // Light purple from design
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.w),
                        topRight: Radius.circular(20.w),
                        bottomLeft: Radius.circular(20.w),
                        bottomRight: Radius.circular(4.w),
                      ),
                    ),
                    child: CustomText(
                      text: message.text,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      textColor: const Color(0xFF111111),
                      maxLines: 10,
                    ),
                  ),
                  if (message.time.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    CustomText(
                      text: message.time,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      textColor: const Color(0xFF9CA3AF),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: chatUser.avatarUrl != null &&
                          chatUser.avatarUrl!.isNotEmpty
                      ? NetworkImage(chatUser.avatarUrl!) as ImageProvider
                      : AssetImage(
                          chatUser.imagePath.isNotEmpty
                              ? chatUser.imagePath
                              : ImagePath.johnDoe,
                        ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: '$firstName ',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        textColor: const Color(0xFF6B7280),
                      ),
                      CustomText(
                        text: message.time,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        textColor: const Color(0xFF6B7280),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    constraints: BoxConstraints(maxWidth: 280.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF9FAFB,
                      ), // Very light grey from design
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.w),
                        topRight: Radius.circular(20.w),
                        bottomLeft: Radius.circular(20.w),
                        bottomRight: Radius.circular(20.w),
                      ),
                    ),
                    child: CustomText(
                      text: message.text,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      textColor: const Color(0xFF111111),
                      maxLines: 10,
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

  Widget _buildMessageInput(BuildContext context, ChatDetailsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: 30.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(25.h),
              ),
              child: Center(
                child: TextField(
                  controller: controller.textController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.messageHint,
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF111111),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => controller.sendMessage(),
            child: Container(
              width: 50.h,
              height: 50.h,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.send, // Send icon
                  color: const Color(0xFF0D1B3E),
                  size: 24.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
