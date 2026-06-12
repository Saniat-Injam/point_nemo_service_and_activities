enum NotificationType {
  general,
  bookingUpdate,
  message,
  groupMessage,
  systemAlert,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final NotificationType type;
  final bool read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.read = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType getNotificationType(String? type, String title) {
      if (type != null) {
        switch (type.toUpperCase()) {
          case 'GENERAL':
            return NotificationType.general;
          case 'BOOKING_UPDATE':
            return NotificationType.bookingUpdate;
          case 'MESSAGE':
            return NotificationType.message;
          case 'GROUP_MESSAGE':
            return NotificationType.groupMessage;
          case 'SYSTEM_ALERT':
            return NotificationType.systemAlert;
        }
      }

      final lowercaseTitle = title.toLowerCase();
      if (lowercaseTitle.contains('message')) {
        return NotificationType.message;
      } else if (lowercaseTitle.contains('booking')) {
        return NotificationType.bookingUpdate;
      } else if (lowercaseTitle.contains('alert')) {
        return NotificationType.systemAlert;
      }
      return NotificationType.general;
    }

    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['body'] ?? '',
      date: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      type: getNotificationType(json['type'], json['title'] ?? ''),
      read: json['read'] ?? false,
    );
  }
}
