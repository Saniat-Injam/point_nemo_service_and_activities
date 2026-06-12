enum BookingStatus { upcoming, completed, cancelled, rejected }

class BookingMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const BookingMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory BookingMetaModel.fromJson(Map<String, dynamic> json) {
    return BookingMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class BookingServiceOwner {
  final String id;
  final String fullName;
  final String email;

  const BookingServiceOwner({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory BookingServiceOwner.fromJson(Map<String, dynamic> json) {
    return BookingServiceOwner(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class BookingServiceModel {
  final String id;
  final String type;
  final String name;
  final String description;
  final String address;
  final double price;
  final String coverImage;
  final double averageRating;
  final int totalRating;
  final BookingServiceOwner owner;

  const BookingServiceModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.address,
    required this.price,
    required this.coverImage,
    required this.averageRating,
    required this.totalRating,
    required this.owner,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      coverImage: json['coverImage'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalRating: json['totalRating'] ?? 0,
      owner: BookingServiceOwner.fromJson(json['owner'] ?? {}),
    );
  }
}

class UserBookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final int numberOfDays;
  final int capacityRequest;
  final double totalAmount;
  final String status;
  final String? paymentId;
  final String createdAt;
  final BookingServiceModel service;

  // Computed helpers used by the UI
  BookingStatus get bookingStatus {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'REJECTED':
        return BookingStatus.rejected;
      default:
        return BookingStatus.upcoming;
    }
  }

  String get title => service.name;
  String get category => service.type;
  String get location => service.address;
  double get price => totalAmount;
  String get coverImage => service.coverImage;

  // Format start date as e.g. "Mar 17, 2026"
  String get formattedDate {
    try {
      final dt = DateTime.parse(startDate);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return startDate;
    }
  }

  const UserBookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfDays,
    required this.capacityRequest,
    required this.totalAmount,
    required this.status,
    this.paymentId,
    required this.createdAt,
    required this.service,
  });

  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    return UserBookingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      numberOfDays: json['numberOfDays'] ?? 1,
      capacityRequest: json['capacityRequest'] ?? 1,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
      paymentId: json['paymentId'],
      createdAt: json['createdAt'] ?? '',
      service: BookingServiceModel.fromJson(json['service'] ?? {}),
    );
  }
}
