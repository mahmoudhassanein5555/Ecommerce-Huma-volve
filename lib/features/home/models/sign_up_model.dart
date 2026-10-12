
class SignUpModel {
  final String name;
  final String email;
  final String password;
  final String avatar;

  SignUpModel({
    required this.name,
    required this.email,
    required this.password,
    this.avatar = 'https://i.imgur.com/LDOO4Qs.jpg',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }
}
