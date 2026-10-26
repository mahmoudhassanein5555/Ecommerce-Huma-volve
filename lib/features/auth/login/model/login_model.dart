class LoginModel {
  String?accessToken;
  String?refreshToken;

  LoginModel({this.accessToken,this.refreshToken});
  factory LoginModel.fromJson(Map<String,dynamic>json){
    return LoginModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  }



