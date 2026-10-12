class LoginModel {
  final String? accessToken;
  final String? refreshToken;

  LoginModel({this.accessToken, this.refreshToken});

   LoginModel.fromJson(Map<String, dynamic> json) :
      accessToken= json['access_token'],
      refreshToken= json['refresh_token'];
    
  }

