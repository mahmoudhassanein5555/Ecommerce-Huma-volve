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
}
