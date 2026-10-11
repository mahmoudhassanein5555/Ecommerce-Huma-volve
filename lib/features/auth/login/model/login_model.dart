class LoginModel {
  String? accessToken;
  String? refreshToken;

  LoginModel({required this.accessToken, required this.refreshToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
}
