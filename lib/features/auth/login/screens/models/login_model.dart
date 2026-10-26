class LoginModel {
  String? accessToken;
  String? refreshToken;

  LoginModel({
    this.accessToken,
    this.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}