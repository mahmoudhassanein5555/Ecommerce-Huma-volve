import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/models/login_model.dart';

import '../models/login_req_model.dart';

class LoginService {
  ApiClient apiClient;
  LoginService(this.apiClient);
  Future<LoginModel> login({required LoginReqModel loginReqModel}) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": loginReqModel.email, "password": loginReqModel.password},
    );
    final Map<String, dynamic> jsonData = response.data;

    final modelData = LoginModel.fromJson(jsonData);

    return modelData;
  }
}
