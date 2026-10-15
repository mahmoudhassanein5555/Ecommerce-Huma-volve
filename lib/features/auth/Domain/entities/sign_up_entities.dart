class SignUpEntities {
  int id;
  final String email;
  final String password;
  final String name;
  final String imageUrl;
  final String role;
  final String creationAt;
  final String updatedAt;

  SignUpEntities({
    required this.email,
    required this.password,
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.role,
    required this.creationAt,
    required this.updatedAt,
  });
}
