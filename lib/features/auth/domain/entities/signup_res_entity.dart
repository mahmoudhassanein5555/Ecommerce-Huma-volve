class SignupResEntity {
  int id;
  String email;
  String password;
  String name;
  String role;
  String avatar;
  String creationAt;
  String updatedAt;

  SignupResEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });
}
