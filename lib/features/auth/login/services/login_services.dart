import 'package:ecommerce_app_huma_volve/core/constant/api_EndPoint.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/model/login_model.dart';

class LoginServices {
  ApiClient apiclient;
  LoginServices({required this.apiclient});

 Future<LoginModel> Login(String email, String password) async {
  final response=await apiclient.dio.post(ApiEndPoints.Login, data: {
      "email": email,
      "password": password,
    });
   Map<String, dynamic>data= response.data;
   LoginModel loginModel=LoginModel.fromJson(data);
   return loginModel;

  }
}
