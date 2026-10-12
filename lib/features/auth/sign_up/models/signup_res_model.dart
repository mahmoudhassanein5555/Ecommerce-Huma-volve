class SignupResModel {
  final int? id;
  final String? email;
  final String? name;
  final String? role;
  final String? avatar;

  SignupResModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory SignupResModel.fromJson(Map<String, dynamic> json) {
    return SignupResModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }
}
