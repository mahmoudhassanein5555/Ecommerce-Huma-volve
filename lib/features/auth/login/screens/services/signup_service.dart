import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/Network/api_clint.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/screens/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/screens/models/signup_res_model.dart';

class SignupService {
  Apiclient apiclient;
  SignupService(this.apiclient);
 Future<SignupResModel> signUp(SignupReqModel SignupReqModel)async{
    final Response = await apiclient.dio.post(ApiEndpoints.signupEndpoint,data: {
      "email":SignupReqModel.email,
  "name": SignupReqModel.name,
  "password": SignupReqModel.password,
  
  "avatar": "https://api.lorem.space/image/face?w=640&h=480",
    });
    final jsonData = Response.data;
    final dartData = SignupResModel.fromJson(jsonData);
    return dartData;
  }
}