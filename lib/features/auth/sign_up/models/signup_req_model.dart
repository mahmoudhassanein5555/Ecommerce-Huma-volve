class SignupReqModel {
  final String name;
  final String email;
  final String password;

  SignupReqModel({
    required this.email,
    required this.name,
    required this.password,
  });
}