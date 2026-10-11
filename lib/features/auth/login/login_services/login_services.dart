import 'package:ecommerce_app_huma_volve/core/constants/api_endPoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginServices {
  ApiClient apiClient;

  LoginServices(this.apiClient);

 Future<LoginModel> login(String email, String password) async{

   final response = await apiClient.dio.post(ApiEndpoints.loginEndPoint,
       data:{"email":email, "password":password} );
   final data = response.data;

   final modelData = LoginModel.fromJson(data);

   return modelData;
  }
}