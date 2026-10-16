import '../../domain/entities/auth_user.dart';

class AuthUserDto {
  const AuthUserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
  });

  final int id;
  final String email;
  final String name;
  final String avatar;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final email = json['email'];
    final name = json['name'];
    final avatar = json['avatar'];
    if (id is! int ||
        email is! String ||
        name is! String ||
        (avatar != null && avatar is! String)) {
      throw const FormatException('The profile response is incomplete.');
    }
    return AuthUserDto(
      id: id,
      email: email,
      name: name,
      avatar: avatar as String? ?? '',
    );
  }

  AuthUser toEntity() =>
      AuthUser(id: id, email: email, name: name, avatar: avatar);
}
