class LoginModel {
  final String? accessToken;
  final String? refreshToken;

  LoginModel({this.accessToken, this.refreshToken});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }
}
