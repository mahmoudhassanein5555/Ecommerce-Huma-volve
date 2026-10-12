import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_EndPoint.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/model/sign_up_model.dart';

class SignUpServices {
  ApiClient apiClient;
  SignUpServices({required this.apiClient});
  Future<SignUpModel> SingUp(String email, String password, String name) async {
    final Response = await apiClient.dio.post(
      ApiEndPoints.signUp,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
      },
    );
    Map<String, dynamic> Data = Response.data;
    SignUpModel signUpModel = SignUpModel.fromJson(Data);
    return signUpModel;
  }
}
