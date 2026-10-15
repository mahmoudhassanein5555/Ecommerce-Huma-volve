class SignUpModel {
  int id;
  final String email;
  final String password;
  final String name;
  final String imageUrl;
  final String role;
  final String creationAt;
  final String updatedAt;

  SignUpModel({
    required this.email,
    required this.password,
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.role,
    required this.creationAt,
    required this.updatedAt,
  });
  SignUpModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? '0',
      email = json['email'],
      password = json['password'],
      name = json['name'],
      imageUrl = json['avatar'],
      role = json['role'],
      creationAt = json['creationAt'],
      updatedAt = json['updatedAt'];
}
