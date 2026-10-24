import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/model/user_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/model/user_response_model.dart';

class SignupService {
  final ApiClient apiClient;

  SignupService(this.apiClient);

  
Future<UserResponseModel> signup(UserModel user) async {
  try {
    final response = await apiClient.dio.post(
      ApiEndpoint.signup,
      data: user.toJson(),
    );

    return UserResponseModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  } on DioException catch (e) {
    final data = e.response?.data;
    final message = data is Map
        ? data['message']?.toString()
        : null;

    throw Exception(message ?? 'Sign Up failed');
  }
}

}





