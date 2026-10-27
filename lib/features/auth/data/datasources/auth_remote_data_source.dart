import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../api/auth_api_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiService);

  final AuthApiService _apiService;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        LoginRequestModel(email: email, password: password),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AppException(
          'Unexpected response from server. Please try again.',
        );
      }
      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
