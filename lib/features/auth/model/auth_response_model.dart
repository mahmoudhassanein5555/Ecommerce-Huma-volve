
class AuthResponseModel {
  final String? accessToken;
  final String? refreshToken;

  AuthResponseModel({
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] ?? json['accessToken'],
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
    );
  }
}
