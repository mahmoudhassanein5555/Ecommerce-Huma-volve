import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatar,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    final avatar = json['avatar'];
    if (id is! num ||
        name is! String ||
        email is! String ||
        avatar is! String) {
      throw const FormatException('Invalid user response from store.');
    }
    return AuthUserModel(
      id: id.toInt(),
      name: name,
      email: email,
      avatar: avatar,
    );
  }
}
