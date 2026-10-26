import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_request_model.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImp(this.apiClient);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    final loginModel = LoginModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );

    await SecureStorage.saveAccessToken(loginModel.accessToken);
    await SecureStorage.saveRefreshToken(loginModel.refreshToken);
    return loginModel;
  }

  @override
  Future<SignupModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final request = SignupRequestModel(
      name: name,
      email: email,
      password: password,
    );
    final response = await apiClient.dio.post(
      ApiEndpoints.signUpEndpoint,
      data: request.toJson(),
    );

    return SignupModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
