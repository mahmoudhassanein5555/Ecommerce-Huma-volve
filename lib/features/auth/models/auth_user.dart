class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
  });

  final int id;
  final String email;
  final String name;
  final String avatar;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final email = json['email'];
    final name = json['name'];

    if (id is! int || email is! String || name is! String) {
      throw const FormatException('The profile response is incomplete.');
    }

    return AuthUser(
      id: id,
      email: email,
      name: name,
      avatar: json['avatar'] is String ? json['avatar'] as String : '',
    );
  }
}
