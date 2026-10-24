
class UserModel {
  final String email;
  final String password;
  final String? name;
  final String? avatar;

  UserModel({
    required this.email,
    required this.password,
    this.name,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
