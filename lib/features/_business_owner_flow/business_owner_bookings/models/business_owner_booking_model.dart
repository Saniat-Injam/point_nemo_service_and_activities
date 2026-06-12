import 'package:intl/intl.dart';

class BusinessOwnerBookingModel {
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

  BusinessOwnerBookingModel({
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

  factory BusinessOwnerBookingModel.fromJson(Map<String, dynamic> json) {
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

    return BusinessOwnerBookingModel(
      id: json['id'] ?? '',
      userName: user['fullName'] ?? '',
      userImage: user['profileImage'] ?? '',
      serviceName: service['name'] ?? '',
      date: formattedDate,
      time: json['startTime'] ?? '',
      location: service['address'] ?? '',
      price: '\$${json['totalAmount'] ?? 0}',
      status: _mapStatus(json['status'] ?? ''),
    );
  }

  static String _mapStatus(String apiStatus) {
    switch (apiStatus.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'ACCEPTED':
      case 'ACTIVE':
        return 'Accepted';
      case 'COMPLETED':
        return 'Completed';
      case 'REJECTED':
        return 'Rejected';
      default:
        return apiStatus;
    }
  }
}
