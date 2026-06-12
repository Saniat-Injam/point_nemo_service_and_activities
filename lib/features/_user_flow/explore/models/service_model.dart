class ServiceModel {
  final String id;
  final String ownerId;
  final String type;
  final String name;
  final String description;
  final String address;
  final double price;
  final String coverImage;
  final List<String> photos;
  final String createdAt;
  final double averageRating;
  final int totalRating;
  final String dailyStartTime;
  final String dailyEndTime;

  ServiceModel({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.name,
    required this.description,
    required this.address,
    required this.price,
    required this.coverImage,
    required this.photos,
    required this.createdAt,
    required this.averageRating,
    required this.totalRating,
    required this.dailyStartTime,
    required this.dailyEndTime,
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
      coverImage: json['coverImage'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      createdAt: json['createdAt'] ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRating: (json['totalRating'] as num?)?.toInt() ?? 0,
      dailyStartTime: json['dailyStartTime'] ?? '',
      dailyEndTime: json['dailyEndTime'] ?? '',
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
