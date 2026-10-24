import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_manager.dart';
import '../models/login_model.dart';

class LoginService {
  final ApiManager apiManager;

  LoginService(this.apiManager);

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiManager.dio.post(
      ApiEndPoints.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);
    await SecureStorage().saveAccessToken(modelData.accessToken);
    await SecureStorage().saveRefreshToken(modelData.refreshToken);
    return modelData;
  }
}
