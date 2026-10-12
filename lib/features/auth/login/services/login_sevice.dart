import 'package:ecommerce_app_huma_volve/core/constants/api_endpioints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginSevice {
  ApiClient apiClient;
  LoginSevice(this.apiClient);
  Future<LoginModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpioints.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      final jsonData = response.data;
      final modelData = LoginModel.fromJson(jsonData);
      return modelData;
    } catch (e) {
      rethrow;
    }
  }
}
