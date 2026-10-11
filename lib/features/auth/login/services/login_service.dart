
import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

class LoginService {
  ApiService apiservice;
  LoginService(ApiService apiService, {required this.apiservice});

  Future<LoginModel> login({required String email, required String password}) async {
    final response = await apiservice.dio.post(
      ApiConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    return LoginModel.fromJson(response.data);
  }
}
