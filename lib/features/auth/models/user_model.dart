/// User returned by `POST users` (sign up) and `GET auth/profile`.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] is int
            ? json['id'] as int
            : int.tryParse('${json['id']}') ?? 0,
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        avatar: json['avatar']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
      );
}
