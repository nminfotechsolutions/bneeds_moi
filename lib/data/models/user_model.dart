// lib/data/models/user_model.dart

class UserModel {
  final String cloudId;
  final String userId;
  final String username;

  UserModel({required this.cloudId, required this.userId, required this.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      cloudId: json['Cloudid'] ?? '',
      userId: json['userid'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
