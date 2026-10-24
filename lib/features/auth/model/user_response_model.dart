
class UserResponseModel {
  final int id;
  final String email;
  final String name;
  final String avatar;
  final String role;

  UserResponseModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.role,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      role: json['role'] as String,
    );
  }
}
