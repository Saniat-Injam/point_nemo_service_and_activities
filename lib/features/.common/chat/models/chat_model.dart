import 'package:point_nemo_service_and_activities/core/utils/constants/image_path.dart';
import 'package:point_nemo_service_and_activities/core/services/storage_service.dart';

class ChatModel {
  final String id; // The other participant's user ID (used as receiverId)
  final String? conversationId; // The conversation ID from the server
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String imagePath; // local asset fallback
  final String? avatarUrl; // network image from API

  ChatModel({
    required this.id,
    this.conversationId,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.imagePath = '',
    this.avatarUrl,
  });

  /// Parses a conversation object from the API.
  ///
  /// Example payload from GET /chat/conversations:
  /// ```json
  /// {
  ///   "conversationId": "69cb7a9a1f638a10aba1bef3",
  ///   "participants": [
  ///     {"id": "69cb61f9...", "fullName": "Mr Bifac", "profileImage": "..."},
  ///     {"id": "69c4c8d5...", "fullName": "Mr Rogal", "profileImage": "..."}
  ///   ],
  ///   "lastMessage": "Hello",
  ///   "lastMessageTime": "2026-03-31T07:51:59.482Z"
  /// }
  /// ```
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final participants = json['participants'] as List? ?? [];
    final currentUserId = StorageService.id ?? '';

    // Find the OTHER participant (not the current user).
    Map<String, dynamic> other = {};
    for (final p in participants) {
      final pMap = p as Map<String, dynamic>;
      final pId = (pMap['_id'] ?? pMap['id'] ?? '').toString();
      if (pId != currentUserId && pId.isNotEmpty) {
        other = pMap;
        break;
      }
    }
    // Fallback: if we couldn't identify the other participant,
    // just use the first one.
    if (other.isEmpty && participants.isNotEmpty) {
      other = participants[0] as Map<String, dynamic>;
    }

    // The other participant's user ID (used as receiverId for socket).
    final otherUserId = (other['_id'] ?? other['id'] ?? '').toString();

    // Conversation ID from the server.
    final conversationId =
        (json['conversationId'] ?? json['_id'] ?? json['id'] ?? '').toString();

    // Resolve last-message text
    final lastMsg = json['lastMessage'];
    String lastMsgText = '';
    if (lastMsg is Map) {
      lastMsgText =
          (lastMsg['content'] ?? lastMsg['text'] ?? '').toString();
    } else if (lastMsg is String) {
      lastMsgText = lastMsg;
    }

    // Build a human-readable relative time
    final rawTime =
        (json['lastMessageTime'] ?? json['updatedAt'] ?? json['createdAt'] ?? '')
            .toString();
    String timeLabel = '';
    if (rawTime.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawTime).toLocal();
        final diff = DateTime.now().difference(dt);
        if (diff.inMinutes < 1) {
          timeLabel = 'Just now';
        } else if (diff.inMinutes < 60) {
          timeLabel = '${diff.inMinutes} min ago';
        } else if (diff.inHours < 24) {
          timeLabel = '${diff.inHours}h ago';
        } else {
          timeLabel = '${diff.inDays}d ago';
        }
      } catch (_) {
        timeLabel = rawTime;
      }
    }

    // Resolve avatar URL from the participant object
    final avatarUrl =
        (other['avatar'] ?? other['profileImage'] ?? other['photo'])
            ?.toString();

    return ChatModel(
      id: otherUserId,
      conversationId: conversationId.isNotEmpty ? conversationId : null,
      name: (other['name'] ??
              other['fullName'] ??
              other['userName'] ??
              'Unknown')
          .toString(),
      lastMessage: lastMsgText,
      time: timeLabel,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      imagePath: ImagePath.johnDoe,
      avatarUrl: avatarUrl,
    );
  }
}
