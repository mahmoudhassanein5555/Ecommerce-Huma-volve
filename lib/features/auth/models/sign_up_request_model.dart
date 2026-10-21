import '../../../core/constants/api_constants.dart';

/// Body of `POST users`.
class SignUpRequestModel {
  final String name;
  final String email;
  final String password;
  final String avatar;

  const SignUpRequestModel({
    required this.name,
    required this.email,
    required this.password,
    this.avatar = ApiConstants.defaultAvatar,
  });

  Map<String, dynamic> toJson() => {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'avatar': avatar,
      };
}
