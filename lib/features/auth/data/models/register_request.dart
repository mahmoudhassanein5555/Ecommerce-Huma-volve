class RegisterRequest {
  final String email;
  final String name;
  final String password;

  const RegisterRequest({
    required this.email,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'role': 'customer',
      'avatar': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    };
  }
}
