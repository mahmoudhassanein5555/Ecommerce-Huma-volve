import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_response.dart';

class LoginService {
  ApiClient apiClient;
  LoginService(this.apiClient);
  login(LoginRequest loginRequest) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": loginRequest.email, "password": loginRequest.password},
    );
    return LoginResponse.fromJson(response.data);
  }
}
