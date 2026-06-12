import 'package:intl/intl.dart';

class CaptainBookingModel {
  final String id;
  final String userName;
  final String userImage;
  final String serviceName;
  final String date;
  final String time;
  final String location;
  final String price;
  final String status; // Pending, Accept, Completed, Rejected
  final double? rating;

  CaptainBookingModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status,
    this.rating,
  });

  factory CaptainBookingModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final service = json['service'] as Map<String, dynamic>? ?? {};

    // Format date from ISO string
    String formattedDate = '';
    if (json['startDate'] != null) {
      final dt = DateTime.tryParse(json['startDate']);
      if (dt != null) {
        formattedDate = DateFormat('MMM dd, yyyy').format(dt);
      }
    }

    return CaptainBookingModel(
      id: json['id'] ?? '',
      userName: user['fullName'] ?? '',
      userImage: user['profileImage'] ?? '',
      serviceName: service['name'] ?? '',
      date: formattedDate,
      time: json['startTime'] ?? '',
      location: service['address'] ?? '',
      price: '\$${json['amount'] ?? 0}',
      status: _mapStatus(json['status'] ?? ''),
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  /// Maps API status values to UI display labels.
  /// The UI uses 'Accept' where the API uses 'active'.
  static String _mapStatus(String apiStatus) {
    switch (apiStatus.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'ACTIVE':
        return 'Accept';
      case 'COMPLETED':
        return 'Completed';
      case 'REJECTED':
        return 'Rejected';
      default:
        return apiStatus;
    }
  }
}
