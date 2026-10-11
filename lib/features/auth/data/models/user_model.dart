class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
  });

  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      avatar: json['avatar'] as String,
    );
  }
}
