class ServiceReviewModel {
  final String id;
  final int rating;
  final String comment;
  final String createdAt;
  final ReviewUserModel? user;
  final int likes;

  ServiceReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.user,
    this.likes = 0,
  });

  factory ServiceReviewModel.fromJson(Map<String, dynamic> json) {
    return ServiceReviewModel(
      id: json['id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] ?? '',
      user: json['user'] != null
          ? ReviewUserModel.fromJson(json['user'])
          : json['userId'] is Map
              ? ReviewUserModel.fromJson(json['userId'])
              : null,
      likes: json['likes'] ?? 0,
    );
  }
}

class ReviewUserModel {
  final String id;
  final String fullName;
  final String profileImage;

  ReviewUserModel({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory ReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewUserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? 'Unknown User',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
