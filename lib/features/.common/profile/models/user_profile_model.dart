class UserProfileModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String gender;
  final String address;

  UserProfileModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.gender,
    required this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'profileImage': profileImage,
        'gender': gender,
        'address': address,
      };
}

