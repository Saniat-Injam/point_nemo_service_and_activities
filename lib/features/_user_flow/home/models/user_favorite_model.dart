import 'package:point_nemo_service_and_activities/features/_user_flow/explore/models/service_model.dart';

class UserFavoriteModel {
  final String id;
  final String userId;
  final String serviceId;
  final String createdAt;
  final String updatedAt;
  final ServiceModel? service;

  UserFavoriteModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    this.service,
  });

  factory UserFavoriteModel.fromJson(Map<String, dynamic> json) {
    return UserFavoriteModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      service: json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
    );
  }
}
