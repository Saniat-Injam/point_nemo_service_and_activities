class BoatRentalDetailsModel {
  final String id;
  final String serviceId;
  final String boatType;
  final String model;
  final int capacity;
  final double length;

  BoatRentalDetailsModel({
    required this.id,
    required this.serviceId,
    required this.boatType,
    required this.model,
    required this.capacity,
    required this.length,
  });

  factory BoatRentalDetailsModel.fromJson(Map<String, dynamic> json) {
    return BoatRentalDetailsModel(
      id: json['id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      boatType: json['boatType'] ?? '',
      model: json['model'] ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      length: (json['length'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BoatRentalModel {
  final String id;
  final String ownerId;
  final String type;
  final String name;
  final String description;
  final String address;
  final double price;
  final String timezone;
  final String dailyStartTime;
  final String dailyEndTime;
  final String coverImage;
  final List<String> photos;
  final List<String> videos;
  final double averageRating;
  final int totalRating;
  final bool isVerifiedByAdmin;
  final String boatType;
  final String createdAt;
  final String updatedAt;
  final BoatRentalDetailsModel? boatRentalDetails;

  BoatRentalModel({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.name,
    required this.description,
    required this.address,
    required this.price,
    required this.timezone,
    required this.dailyStartTime,
    required this.dailyEndTime,
    required this.coverImage,
    required this.photos,
    required this.videos,
    required this.averageRating,
    required this.totalRating,
    required this.isVerifiedByAdmin,
    required this.boatType,
    required this.createdAt,
    required this.updatedAt,
    this.boatRentalDetails,
  });

  factory BoatRentalModel.fromJson(Map<String, dynamic> json) {
    return BoatRentalModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] ?? '',
      dailyStartTime: json['dailyStartTime'] ?? '',
      dailyEndTime: json['dailyEndTime'] ?? '',
      coverImage: json['coverImage'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRating: (json['totalRating'] as num?)?.toInt() ?? 0,
      isVerifiedByAdmin: json['isVerifiedByAdmin'] ?? false,
      boatType: json['boatType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      boatRentalDetails: json['boatRentalDetails'] != null
          ? BoatRentalDetailsModel.fromJson(
              json['boatRentalDetails'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class BoatRentalMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  BoatRentalMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory BoatRentalMetaModel.fromJson(Map<String, dynamic> json) {
    return BoatRentalMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
