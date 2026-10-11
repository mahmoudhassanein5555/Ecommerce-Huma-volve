
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import '../login_model.dart';

class LoginService {
  final ApiClient apiClient;

  LoginService(this.apiClient);

  Future<Response> login(LoginModel loginModel) async {
    return await apiClient.dio.post(
      ApiEndpoints.login,
      data: loginModel.toJson(),
    );
  }
}
