import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({super.accessToken, super.refreshToken});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }
}
