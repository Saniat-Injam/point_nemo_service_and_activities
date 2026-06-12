import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/message_model.dart';
import 'package:point_nemo_service_and_activities/features/.common/chat/models/chat_model.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/core/utils/constants/app_urls.dart';
import 'package:point_nemo_service_and_activities/core/services/socket_service.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';
import 'package:point_nemo_service_and_activities/core/services/network_caller.dart';

class ChatDetailsController extends GetxController {
  // ── Observable state ───────────────────────────────────────────────────
  final messages = <MessageModel>[].obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  /// The conversation / chat user.
  late final Rx<ChatModel> chatUser;

  /// Conversation ID — set from ChatModel.conversationId or from
  /// the `conversation-joined` socket event.
  final conversationId = Rxn<String>();

  /// Whether we are waiting for the conversation to be ready.
  final isJoining = true.obs;

  /// Whether we are loading old chat history.
  final isLoadingHistory = false.obs;

  // Internal helpers
  late final SocketService _socketService;
  final _networkCaller = NetworkCaller();

  String get _currentUserId => StorageService.id ?? '';

  // ── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    // Parse navigation arguments.
    final arg = Get.arguments;
    chatUser = Rx<ChatModel>(
      arg is ChatModel
          ? arg
          : ChatModel(
              id: '',
              name: 'Chat',
              lastMessage: '',
              time: '',
              imagePath: ImagePath.johnDoe,
            ),
    );

    _initSocket();
  }

  // ── Socket Setup ───────────────────────────────────────────────────────

  void _initSocket() {
    // Get or create the SocketService singleton.
    if (Get.isRegistered<SocketService>()) {
      _socketService = Get.find<SocketService>();
    } else {
      _socketService = Get.put(SocketService(), permanent: true);
    }

    // connect() MUST be called first — it creates the _socket object.
    // Without it, _socket is null and all listener calls are silent no-ops.
    _socketService.connect();

    // Clear stale listeners, then register fresh ones.
    _socketService.clearListeners();
    _socketService.onConversationJoined(_handleConversationJoined);
    _socketService.onNewMessage(_handleIncomingMessage);

    // ── Decide which path to take ────────────────────────────────────────
    //
    // PATH A — From chat list: we already have a conversationId.
    //          Skip join-conversation, go straight to fetching history.
    //
    // PATH B — From captain details: we only have the captain's user ID
    //          (receiverId). Emit join-conversation to get/create the
    //          conversationId from the server.

    final existingConvId = chatUser.value.conversationId;
    final receiverId = chatUser.value.id;

    if (existingConvId != null && existingConvId.isNotEmpty) {
      // PATH A — already have conversationId
      log('[ChatDetailsController] PATH A: Already have conversationId: $existingConvId');
      conversationId.value = existingConvId;
      isJoining.value = false;
      _fetchChatHistory(existingConvId);

      // CRITICAL: Even if we have the conversation ID and history, we MUST join
      // the socket room so the server knows to push real-time 'new-message' events to us.
      if (receiverId.isNotEmpty) {
        log('[ChatDetailsController] PATH A: Also emitting join-conversation for real-time updates');
        _socketService.joinConversationWhenReady(receiverId);
      }
    } else if (receiverId.isNotEmpty) {
      // PATH B — need to join/create conversation via socket
      log('[ChatDetailsController] PATH B: Joining with receiverId: $receiverId');
      _socketService.joinConversationWhenReady(receiverId);
    } else {
      isJoining.value = false;
      log('[ChatDetailsController] ERROR: No conversationId or receiverId');
    }
  }

  // ── Socket Callbacks ────────────────────────────────────────────────────

  /// Called when the server confirms the conversation room (PATH B).
  void _handleConversationJoined(Map<String, dynamic> data) {
    final cId = data['conversationId']?.toString();
    if (cId != null && cId.isNotEmpty) {
      conversationId.value = cId;
      isJoining.value = false;
      log('[ChatDetailsController] Conversation joined: $cId');
      _fetchChatHistory(cId);
    }
  }

  /// Called when a new real-time message arrives from the socket.
  void _handleIncomingMessage(Map<String, dynamic> data) {
    final msg = MessageModel.fromJson(data, currentUserId: _currentUserId);
    
    // Avoid duplicates by exact real ID.
    final isDuplicate =
        messages.any((m) => m.id == msg.id && msg.id.isNotEmpty);
    if (isDuplicate) return;

    // If it's our own message echoing back, look for the optimistic placeholder
    // we inserted when sending, and replace it with the real one.
    if (msg.isMe) {
      final optIndex = messages.indexWhere(
          (m) => m.id.startsWith('opt_') && m.text == msg.text);
      if (optIndex != -1) {
        messages[optIndex] = msg;
        return; // Already handled
      }
    }

    // Otherwise, it's a new message (either from the other user, or from us on another device)
    messages.insert(0, msg);
    _scrollToBottom();
  }

  // ── REST: Load Chat History ─────────────────────────────────────────────

  /// Fetches previous messages for [cId] via REST.
  ///
  /// Server response:
  /// { "success": true, "data": { "meta": {...}, "data": [...messages] } }
  Future<void> _fetchChatHistory(String cId) async {
    isLoadingHistory.value = true;
    try {
      final url = AppUrls.getConversationMessages(cId);
      log('[ChatDetailsController] Fetching history: $url');
      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess && response.responseData != null) {
        final body = response.responseData as Map<String, dynamic>;

        // Handle nested { data: { meta, data: [...] } }
        List<dynamic> rawList = [];
        final outerData = body['data'];
        if (outerData is Map) {
          final inner = outerData['data'];
          if (inner is List) rawList = inner;
        } else if (outerData is List) {
          rawList = outerData;
        } else if (body['messages'] is List) {
          rawList = body['messages'] as List;
        } else if (body['result'] is List) {
          rawList = body['result'] as List;
        }

        final history = rawList
            .map((e) => MessageModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                  currentUserId: _currentUserId,
                ))
            .toList();

        // API returns newest first — which matches reverse:true ListView
        // (index 0 = visual bottom = newest message).

        // Merge: keep any real-time messages at the front (bottom),
        // then append history behind them.
        final realTime = messages.toList();
        final historyIds = history.map((m) => m.id).toSet();
        final newRealTime =
            realTime.where((m) => !historyIds.contains(m.id)).toList();

        messages.assignAll([...newRealTime, ...history]);

        log('[ChatDetailsController] Loaded ${history.length} historical messages');
      } else {
        log('[ChatDetailsController] Failed to fetch history: ${response.errorMessage}');
      }
    } catch (e) {
      log('[ChatDetailsController] Error fetching history: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // ── Send Message ───────────────────────────────────────────────────────

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final cId = conversationId.value;
    if (cId == null || cId.isEmpty) {
      log('[ChatDetailsController] Cannot send — no conversationId yet');
      Get.snackbar(
        'Please wait',
        'Connecting to conversation...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Optimistic UI: show the message locally immediately.
    final optimisticId = 'opt_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final timeLabel =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    // insert(0) so new message appears at bottom (reverse:true ListView).
    messages.insert(0, MessageModel(
      id: optimisticId,
      text: text,
      time: timeLabel,
      isMe: true,
    ));

    // Emit through socket.
    _socketService.sendMessage(conversationId: cId, content: text);

    textController.clear();
    _scrollToBottom();
  }

  /// Scroll the reversed ListView to its start (i.e. visual bottom).
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Cleanup ────────────────────────────────────────────────────────────

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    _socketService.disconnect();
    super.onClose();
  }
}
