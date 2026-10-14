import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_model.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImplementation(this.apiClient);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": email, "password": password},
    );
    return LoginModel.fromJson(response.data);
  }

  @override
  Future<SignupModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "email": email.trim(),
        "name": name.trim(),
        "password": password,
        "avatar": "https://api.loren.space/image/face?w=&h=480",
      },
    );
    return SignupModel.fromJson(response.data);
  }
}
