import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response.dart';

class LoginService {
  LoginService(this._dio);

  final Dio _dio;

  Future<LoginResponse> login({required LoginRequest body}) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {
        ApiConstants.email: body.email,
        ApiConstants.password: body.password,
      },
    );
    Map<String, dynamic> jsonData = response.data;
    final modelTokens = LoginResponse.fromJson(jsonData);
    return modelTokens;
  }
}
