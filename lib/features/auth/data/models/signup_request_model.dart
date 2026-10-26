class SignupRequestModel {
  final String name;
  final String email;
  final String password;

  const SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'avatar': 'https://api.lorem.space/image/face?w=640&h=480',
    };
  }
}
