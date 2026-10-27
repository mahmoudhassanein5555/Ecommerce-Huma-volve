import '../../../../core/error/app_exception.dart';
import '../../domain/entities/auth_entity.dart';


class LoginResponseModel {
  const LoginResponseModel({this.accessToken, this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  final String? accessToken;
  final String? refreshToken;

  AuthEntity toEntity() {
    final accessToken = this.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw const AppException(
        'Unexpected response from server. Please try again.',
      );
    }
    return AuthEntity(
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
    );
  }
}
