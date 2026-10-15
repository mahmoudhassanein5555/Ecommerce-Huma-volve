import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/login_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_model.dart';

class LoginDatasourceImp implements LoginDatasource {
  final ApiClient apiClient;
  LoginDatasourceImp(this.apiClient);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );
    final modelData = LoginModel.fromJson(response.data);

    await SecureStorage.saveAccessToken(modelData.accessToken);
    await SecureStorage.saveRefreshToken(modelData.refreshToken);

    return modelData;
  }
}
