class CaptainEmployment {
  final String id;
  final String ownerId;
  final String captainId;
  final String boatType;
  final String startDate;
  final String endDate;
  final double amount;
  final String status;

  CaptainEmployment({
    required this.id,
    required this.ownerId,
    required this.captainId,
    required this.boatType,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.status,
  });

  factory CaptainEmployment.fromJson(Map<String, dynamic> json) {
    return CaptainEmployment(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      captainId: json['captainId'] ?? '',
      boatType: json['boatType'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
    );
  }
}

class CaptainModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String gender;
  final double? captainRate;
  final List<CaptainEmployment> employments;
  final String address;

  CaptainModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.gender,
    this.captainRate,
    required this.employments,
    required this.address,
  });

  factory CaptainModel.fromJson(Map<String, dynamic> json) {
    final List rawEmployments = json['captainEmploymentsAsCaptain'] ?? [];
    return CaptainModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'],
      gender: json['gender'] ?? '',
      captainRate: (json['captainRate'] as num?)?.toDouble(),
      employments:
          rawEmployments.map((e) => CaptainEmployment.fromJson(e)).toList(),
      address: json['address'] ?? '',
    );
  }
}

class CaptainMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  CaptainMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory CaptainMetaModel.fromJson(Map<String, dynamic> json) {
    return CaptainMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
