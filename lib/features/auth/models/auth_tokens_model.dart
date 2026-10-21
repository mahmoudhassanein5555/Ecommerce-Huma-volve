/// Response of `POST auth/login`.
class AuthTokensModel {
  final String accessToken;
  final String? refreshToken;

  const AuthTokensModel({required this.accessToken, this.refreshToken});

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      AuthTokensModel(
        accessToken: json['access_token']?.toString() ?? '',
        refreshToken: json['refresh_token']?.toString(),
      );
}
