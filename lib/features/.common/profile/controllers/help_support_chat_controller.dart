import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:point_nemo_service_and_activities/features/.common/profile/models/chat_message_model.dart';

class HelpSupportChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessageModel> messages = <ChatMessageModel>[
    ChatMessageModel(
      text: '"Welcome to Point Nemo! How can I help you?',
      isUser: false,
    ),
    ChatMessageModel(
      text: 'I want to know a boat details Please help me .',
      isUser: true,
    ),
    ChatMessageModel(text: 'Give me your boat model.', isUser: false),
    ChatMessageModel(
      text: '“2023 Sea Ray 500 Fly” This is the boat model.',
      isUser: true,
    ),
  ].obs;

  void sendMessage() {
    if (textController.text.trim().isNotEmpty) {
      messages.add(
        ChatMessageModel(text: textController.text.trim(), isUser: true),
      );

      textController.clear();
      _scrollToBottom();

      // Simulate bot response
      Future.delayed(const Duration(seconds: 1), () {
        messages.add(
          ChatMessageModel(
            text: "Thanks! Our support team will get back to you shortly.",
            isUser: false,
          ),
        );
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
