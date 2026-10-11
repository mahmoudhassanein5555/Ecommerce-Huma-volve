import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginService {
  final ApiClient apiClient;

  LoginService({required this.apiClient});

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    final Map<String, dynamic> jsonData = response.data as Map<String, dynamic>;
    return LoginModel.fromJson(jsonData);
  }
}