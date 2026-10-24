import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_manager.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginService {
  ApiManager apiManager;
  LoginService(this.apiManager);
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiManager.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {
        "email": email,
        "password": password
      }
    );
    // final response = await apiManager.dio.post<Map<String, dynamic>>(
    //   ApiEndpoints.loginEndpoint,
    //   data: {'email': email, 'password': password},
    // );
    final jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData!);
    print("$response--------------------------------------------------------\n"
        "-------------------------------------------it's ok");
    return modelData;
  }
}
