import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/networks/api_clints.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginService {
  ApiClints apiClints;
  LoginService(this.apiClints);
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClints.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    final Map<String, dynamic> jsonDate = response.data;
    final modelData = LoginModel.fromJson(jsonDate);
    return modelData;
  }
}
