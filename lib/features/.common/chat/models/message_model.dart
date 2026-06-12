class MessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final String? imageUrl;
  final String? senderId;

  MessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.imageUrl,
    this.senderId,
  });

  /// Parse a message from the Socket.IO `new-message` event payload.
  ///
  /// Example payload:
  /// ```json
  /// {
  ///   "id": "69cb6d750ad6d299b55c845d",
  ///   "conversationId": "69c39b3ff5eeaad1d59db8ea",
  ///   "senderId": "69b3a74a455e16003d36f7e1",
  ///   "content": "Nothing to say",
  ///   "imageUrl": null,
  ///   "createdAt": "2026-03-31T06:45:09.726Z"
  /// }
  /// ```
  factory MessageModel.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final senderId = (json['senderId'] ?? '').toString();

    // Build display time from createdAt
    String timeLabel = '';
    final rawTime = (json['createdAt'] ?? '').toString();
    if (rawTime.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawTime).toLocal();
        timeLabel =
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        timeLabel = rawTime;
      }
    }

    return MessageModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      text: (json['content'] ?? json['text'] ?? '').toString(),
      time: timeLabel,
      isMe: senderId == currentUserId,
      imageUrl: json['imageUrl']?.toString(),
      senderId: senderId,
    );
  }
}
