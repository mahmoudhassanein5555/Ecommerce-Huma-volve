
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/model/auth_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/model/user_model.dart';

class LoginService {
  final ApiClient apiClient;

  LoginService(this.apiClient);

  Future<AuthResponseModel> login(UserModel user) async {
    try {
      final Response response = await apiClient.dio.post(
        ApiEndpoint.login,
        data: user.toJson(),
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['message']?.toString()
          : null;

      throw Exception(message ?? 'Login failed');
    }
  }
}
