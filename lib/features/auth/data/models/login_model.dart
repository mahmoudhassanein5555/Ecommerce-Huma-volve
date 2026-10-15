import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({required super.accessToken, required super.refreshToken});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    accessToken: json["access_token"] ?? "",
    refreshToken: json["refresh_token"] ?? "",
  );

  //toEntity
  LoginEntity toEntity() =>
      LoginEntity(accessToken: accessToken, refreshToken: refreshToken);
}
