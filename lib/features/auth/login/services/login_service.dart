import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_response.dart';

class LoginService {
 Future<LoginResponse> login({required LoginRequest body}) async {
    final response = await ApiClient.instance.post(
      ApiEndpoints.login,
      data: {
        ApiConstants.email: body.email,
        ApiConstants.password: body.password
      }
    );
    Map<String,dynamic> jsonData = response.data;
    final modelTokens = LoginResponse.fromJson(jsonData);
    return modelTokens;
  }
}