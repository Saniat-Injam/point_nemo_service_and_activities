import 'dart:developer';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';

/// Singleton Socket.IO service managed by GetX.
///
/// Socket server URL: http://206.162.244.142:5017
///
/// Flow (confirmed with Postman):
///   1. Connect (auth via token in headers + auth payload).
///   2. Emit  `join-conversation`  →  { receiverId }
///   3. Listen `conversation-joined` → { conversationId }
///   4. Emit  `send-message`        →  { conversationId, content }
///   5. Listen `new-message`        → full message object
class SocketService extends GetxService {
  static const String _socketUrl = 'http://206.162.244.142:5017';

  io.Socket? _socket;

  /// Observable connection state so UI can react.
  final isConnected = false.obs;

  /// Pending receiverId to join once the socket connects.
  String? _pendingReceiverId;

  // ── Connect ───────────────────────────────────────────────────────────

  void connect() {
    if (_socket != null && _socket!.connected) {
      log('[SocketService] Already connected');
      return;
    }

    // Dispose any stale socket before creating a new one.
    _socket?.dispose();
    _socket = null;

    final token = StorageService.token;

    _socket = io.io(
      _socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders(
              token != null ? {'Authorization': 'Bearer $token'} : {})
          .setAuth(token != null ? {'token': token} : {})
          .build(),
    );

    _socket!.onConnect((_) {
      log('[SocketService] Connected to $_socketUrl');
      isConnected.value = true;
      // If a receiverId was queued before connection, emit now.
      if (_pendingReceiverId != null) {
        _emitJoinConversation(_pendingReceiverId!);
        _pendingReceiverId = null;
      }
    });

    _socket!.onDisconnect((_) {
      log('[SocketService] Disconnected');
      isConnected.value = false;
    });

    _socket!.onConnectError((error) {
      log('[SocketService] Connection error: $error');
      isConnected.value = false;
    });

    _socket!.onError((error) {
      log('[SocketService] Error: $error');
    });

    _socket!.connect();
  }

  // ── Emitters ──────────────────────────────────────────────────────────

  /// Join / create a conversation with [receiverId].
  /// If the socket is not yet connected, queues the emit for when it connects.
  void joinConversationWhenReady(String receiverId) {
    if (_socket != null && _socket!.connected) {
      _emitJoinConversation(receiverId);
    } else {
      log('[SocketService] Socket not connected yet — queuing join for: $receiverId');
      _pendingReceiverId = receiverId;
    }
  }

  void _emitJoinConversation(String receiverId) {
    log('[SocketService] Emitting join-conversation → receiverId: $receiverId');
    _socket?.emit('join-conversation', {'receiverId': receiverId});
  }

  /// Send a message to [conversationId].
  void sendMessage({
    required String conversationId,
    required String content,
  }) {
    log('[SocketService] Emitting send-message → conversationId: $conversationId');
    _socket?.emit('send-message', {
      'conversationId': conversationId,
      'content': content,
    });
  }

  // ── Listeners ─────────────────────────────────────────────────────────

  /// Remove ALL chat-related socket listeners.
  /// Call this before re-registering to prevent duplicate callbacks.
  void clearListeners() {
    _socket?.off('conversation-joined');
    _socket?.off('new-message');
    _socket?.off('user-typing');
    _socket?.off('new-message-notification');
    log('[SocketService] Cleared all listeners');
  }

  /// Server payload: { "conversationId": "..." }
  void onConversationJoined(void Function(Map<String, dynamic> data) callback) {
    _socket?.on('conversation-joined', (data) {
      log('[SocketService] conversation-joined: $data');
      final mapped = _toMap(data);
      if (mapped != null) callback(mapped);
    });
  }

  /// Server payload example:
  /// { "id": "...", "conversationId": "...", "senderId": "...", "content": "...", ... }
  void onNewMessage(void Function(Map<String, dynamic> data) callback) {
    _socket?.on('new-message', (data) {
      log('[SocketService] new-message: $data');
      final mapped = _toMap(data);
      if (mapped != null) callback(mapped);
    });
  }

  /// Optional typing indicator.
  void onUserTyping(void Function(dynamic data) callback) {
    _socket?.on('user-typing', (data) {
      log('[SocketService] user-typing: $data');
      callback(data);
    });
  }

  /// Optional notification listener.
  void onNewMessageNotification(void Function(dynamic data) callback) {
    _socket?.on('new-message-notification', (data) {
      log('[SocketService] new-message-notification: $data');
      callback(data);
    });
  }

  // ── Disconnect ────────────────────────────────────────────────────────

  void disconnect() {
    log('[SocketService] Disconnecting...');
    clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    isConnected.value = false;
    _pendingReceiverId = null;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  // ── Utility ───────────────────────────────────────────────────────────

  Map<String, dynamic>? _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
