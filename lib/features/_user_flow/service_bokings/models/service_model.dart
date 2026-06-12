


class ServiceAdditionalModel {
  final String id;
  final String serviceId;
  final String name;
  final double price;
  final String description;

  ServiceAdditionalModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ServiceAdditionalModel.fromJson(Map<String, dynamic> json) {
    return ServiceAdditionalModel(
      id: json['id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}

class ServiceOwnerModel {
  final String id;
  final String fullName;
  final String email;

  ServiceOwnerModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory ServiceOwnerModel.fromJson(Map<String, dynamic> json) {
    return ServiceOwnerModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class ServiceBoatRentalDetails {
  final String id;
  final String serviceId;
  final String boatType;
  final String model;
  final int capacity;
  final double length;

  ServiceBoatRentalDetails({
    required this.id,
    required this.serviceId,
    required this.boatType,
    required this.model,
    required this.capacity,
    required this.length,
  });

  factory ServiceBoatRentalDetails.fromJson(Map<String, dynamic> json) {
    return ServiceBoatRentalDetails(
      id: json['id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      boatType: json['boatType'] ?? '',
      model: json['model'] ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      length: (json['length'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ServiceModel {
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
  final String createdAt;
  final String updatedAt;
  final ServiceBoatRentalDetails? boatRentalDetails;
  final List<ServiceAdditionalModel> additionalServices;
  final ServiceOwnerModel? owner;
  bool isFavorite;

  ServiceModel({
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
    required this.createdAt,
    required this.updatedAt,
    this.boatRentalDetails,
    required this.additionalServices,
    this.owner,
    this.isFavorite = false,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
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
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      boatRentalDetails: json['boatRentalDetails'] != null
          ? ServiceBoatRentalDetails.fromJson(
              json['boatRentalDetails'] as Map<String, dynamic>,
            )
          : null,
      additionalServices: (json['additionalServices'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ServiceAdditionalModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      owner: json['owner'] != null
          ? ServiceOwnerModel.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      isFavorite: json['isFavorite'] ??
          (json['favoriteServices'] != null &&
              (json['favoriteServices'] as List).isNotEmpty),
    );
  }
}

class ServiceMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ServiceMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ServiceMetaModel.fromJson(Map<String, dynamic> json) {
    return ServiceMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Models for GET /service/:id  (single-service detail endpoint)
// ─────────────────────────────────────────────────────────────────

class ServiceAvailabilityModel {
  final String id;
  final String serviceId;
  final String startTime;
  final String endTime;

  ServiceAvailabilityModel({
    required this.id,
    required this.serviceId,
    required this.startTime,
    required this.endTime,
  });

  factory ServiceAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return ServiceAvailabilityModel(
      id: json['id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

class ServiceDetailModel {
  final String id;
  final String ownerId;
  final String type;
  final String name;
  final String description;
  /// Top-level location string returned by the detail endpoint.
  final String location;
  final String address;
  final double price;
  final String coverImage;
  final List<String> photos;
  final List<String> videos;
  final String createdAt;
  final String updatedAt;
  final ServiceBoatRentalDetails? boatRentalDetails;
  final List<ServiceAdditionalModel> additionalServices;
  final List<ServiceAvailabilityModel> availabilities;
  final String dailyStartTime;
  final String dailyEndTime;
  final ServiceOwnerModel? owner;
  bool isFavorite;

  ServiceDetailModel({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    required this.price,
    required this.coverImage,
    required this.photos,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
    this.boatRentalDetails,
    required this.additionalServices,
    required this.availabilities,
    required this.dailyStartTime,
    required this.dailyEndTime,
    this.owner,
    this.isFavorite = false,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: _parseLocation(json['location']),
      address: json['address'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      dailyStartTime: json['dailyStartTime'] ?? '',
      dailyEndTime: json['dailyEndTime'] ?? '',
      coverImage: json['coverImage'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      boatRentalDetails: json['boatRentalDetails'] != null
          ? ServiceBoatRentalDetails.fromJson(
              json['boatRentalDetails'] as Map<String, dynamic>,
            )
          : null,
      additionalServices: (json['additionalServices'] as List<dynamic>?)
              ?.map(
                (e) => ServiceAdditionalModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      availabilities: (json['availabilities'] as List<dynamic>?)
              ?.map(
                (e) => ServiceAvailabilityModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      owner: json['owner'] != null
          ? ServiceOwnerModel.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      isFavorite: json['isFavorite'] ??
          (json['favoriteServices'] != null &&
              (json['favoriteServices'] as List).isNotEmpty),
    );
  }

  /// Safely handles location as either a plain String (detail endpoint)
  /// or a {"long": "...", "lat": "..."} Map (list endpoint).
  static String _parseLocation(dynamic raw) {
    if (raw == null) return '';
    if (raw is String) return raw;
    if (raw is Map) {
      final lat = raw['lat'] ?? '';
      final lng = raw['long'] ?? '';
      if (lat.toString().isNotEmpty && lng.toString().isNotEmpty) {
        return '$lat, $lng';
      }
    }
    return '';
  }
}
