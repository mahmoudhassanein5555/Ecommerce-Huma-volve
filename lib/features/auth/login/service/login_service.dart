import 'package:ecommerce_app_huma_volve/core/network_service/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

import '../../../../core/constant/api_end_point.dart';

class LoginService {
  NetworkServices networkServices;

  LoginService({required this.networkServices});

  Future<LoginModel> login(String email, String password) async {
    final response = await networkServices.dio.post(
      ApiEndPoint.login,
      data: {'email': email, 'password': password},
    );
    final jsonResponse = response.data;
    final loginModel = LoginModel.fromJson(jsonResponse);
    return loginModel;
  }
}
