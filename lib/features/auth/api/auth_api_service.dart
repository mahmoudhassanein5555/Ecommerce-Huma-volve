import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../data/models/login_request_model.dart';
import 'auth_api_constants.dart';

class AuthApiService {
  const AuthApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<Response<dynamic>> login(LoginRequestModel request) {
    return _apiClient.dio.post(
      AuthApiConstants.loginEndpoint,
      data: request.toJson(),
    );
  }
}
