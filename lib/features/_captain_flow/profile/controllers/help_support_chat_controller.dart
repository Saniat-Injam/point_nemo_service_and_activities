// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:point_nemo_service_and_activities/features/_captain_flow/profile/models/chat_message_model.dart';

// class HelpSupportChatController extends GetxController {
//   final TextEditingController textController = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   final RxList<ChatMessageModel> messages = <ChatMessageModel>[
//     ChatMessageModel(
//       text: '"Welcome to CarLanda! How can I help you?',
//       isUser: false,
//     ),
//     ChatMessageModel(
//       text: 'I want to know a car details Please help me .',
//       isUser: true,
//     ),
//     ChatMessageModel(text: 'Give me your car model.', isUser: false),
//     ChatMessageModel(
//       text: '“2023 Tesla model S” This is the car model.',
//       isUser: true,
//     ),
//   ].obs;

//   void sendMessage() {
//     if (textController.text.trim().isNotEmpty) {
//       messages.add(
//         ChatMessageModel(text: textController.text.trim(), isUser: true),
//       );

//       textController.clear();
//       _scrollToBottom();

//       // Simulate bot response
//       Future.delayed(const Duration(seconds: 1), () {
//         messages.add(
//           ChatMessageModel(
//             text: "Thanks! Our support team will get back to you shortly.",
//             isUser: false,
//           ),
//         );
//         _scrollToBottom();
//       });
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void onClose() {
//     textController.dispose();
//     scrollController.dispose();
//     super.onClose();
//   }
// }
