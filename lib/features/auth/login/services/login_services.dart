import 'dart:async';
import 'dart:math';

import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../features/auth/login/models/loginModels.dart';
class loginService{
  ApiClient apiClient;
  loginService(this.apiClient);
  Future<loginModels> login({required String email, required String password})async{
final response = await apiClient.dio.post(ApiEndpoints.loginEndpoints,data:
{"email": email,
  "password": password}
);
final Map<String,dynamic> jsonData= response.data;
final modelData=loginModels.fromJson(jsonData);
await secureStorage.saveAccessToken(modelData.accessToken);
await secureStorage.saveRefreshToken(modelData.refreshToken);
return modelData;
  }

}