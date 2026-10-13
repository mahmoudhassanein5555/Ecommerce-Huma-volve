import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';

import '../../../../core/network/api_client.dart';
import 'models/login_model.dart';

class LoginService {
  ApiClient apiClient;

  LoginService(this.apiClient);

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": email, "password": password},
    );
    final jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);
    return modelData;
  }
}
