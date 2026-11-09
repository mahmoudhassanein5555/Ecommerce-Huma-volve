class TokenModel {
  String accessToken;
  String? refreshToken;

  TokenModel({required this.accessToken, this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}
