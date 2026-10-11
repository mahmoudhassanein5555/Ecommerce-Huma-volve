import 'package:ecommerce_app_huma_volve/core/constant/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginService {
  ApiClient apiClient;
  LoginService(this.apiClient);
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoint.loginEndPoint,
      data: {"email": email, "password": password},
    );
    final Map<String, dynamic> json = response.data;
    final modelData = LoginModel.fromJson(json);  

   
    return modelData;
  }
}
