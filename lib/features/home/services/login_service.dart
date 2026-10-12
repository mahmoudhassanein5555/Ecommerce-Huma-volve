
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_client.dart';

import '../models/login_model.dart';

class LoginService {
  final ApiClient apiClient;

  LoginService(this.apiClient);

  Future<Response> login(LoginModel loginModel) async {
    return await apiClient.dio.post(
      '/auth/login',
      data: loginModel.toJson(),
    );
  }
}
