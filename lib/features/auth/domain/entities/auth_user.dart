class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  final int id;
  final String name;
  final String email;
  final String avatar;
}
