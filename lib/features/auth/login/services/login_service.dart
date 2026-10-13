import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/services/models/login_model.dart';

class LoginService {
  final ApiClient apiClient;

  LoginService(this.apiClient);

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {
        "email": email,
        "password": password,
      },
    );

    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);

    print("Access Token: ${modelData.accessToken}");
    print("Refresh Token: ${modelData.refreshToken}");

    return modelData;
  }
}