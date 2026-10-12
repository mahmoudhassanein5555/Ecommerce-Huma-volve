class LoginModel {
  String? accessToken;
  String? refreshToken;

  LoginModel({this.accessToken, this.refreshToken});

  LoginModel.fromJson(Map<String,dynamic> json){
    accessToken=json['accessToken'];
    refreshToken=json['refreshToken'];
  }
}