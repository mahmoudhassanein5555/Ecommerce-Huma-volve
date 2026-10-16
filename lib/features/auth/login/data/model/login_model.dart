import 'package:ecommerce_app_huma_volve/features/auth/login/domain/entity/login_entity.dart';

class LoginModel extends LoginEntity{


  LoginModel({super.accessToken, super.refreshToken});

  LoginModel.fromJson(Map<String,dynamic> json){
    accessToken=json['accessToken'];
    refreshToken=json['refreshToken'];
  }
}