import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/core/custom/more_widgets/custom_text_style.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_colors.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_sizer.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/controllers/help_support_chat_controller.dart';
import 'package:point_nemo_service_and_activities/features/.common/profile/views/widgets/custom_chat_message_bubble.dart';
import 'package:point_nemo_service_and_activities/core/localization/app_localizations.dart';

class HelpSupportChatDialog extends StatelessWidget {
  const HelpSupportChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final HelpSupportChatController controller = Get.put(
      HelpSupportChatController(),
    );

    return Dialog(
      backgroundColor: Colors.transparent, // We wrap to provide rounded corners
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.w),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.75,
          color: const Color(0xFF141A29), // Dark blue background
          child: Column(
            children: [
              // --- Header ---
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                color: const Color(0xFF141A29),
                child: Row(
                  children: [
                    // Bot Avatar
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/piku.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Title
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.helpSupport,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Close/Minimize icon
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.white,
                        size: 26.w,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Chat Messages Area ---
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      return CustomChatMessageBubble(
                        text: msg.text,
                        isUser: msg.isUser,
                      );
                    },
                  );
                }),
              ),

              // --- Bottom Input Area ---
              Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 12.h,
                  bottom: 24.h,
                ),
                color: const Color(0xFF141A29),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          style: getTextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.askYourQuestion,
                            hintStyle: getTextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFC7CBD1), // Light grey hint
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.h,
                            ),
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.sendMessage(),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: const BoxDecoration(
                            color: Color(
                              0xFF0B1426,
                            ), // Very dark blue for button
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


