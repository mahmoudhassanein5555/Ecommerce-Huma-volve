import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/auth_tokens_dto.dart';
import '../models/auth_user_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthTokensDto> login(String email, String password);
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String avatar,
  });
  Future<AuthUserDto> getProfile(String accessToken);
  Future<AuthTokensDto> refresh(String refreshToken);
}

class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  DioAuthRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  @override
  Future<AuthTokensDto> login(String email, String password) async {
    final response = await _dio.post<dynamic>(
      '/auth/login',
      data: {'email': email.trim(), 'password': password},
    );
    return AuthTokensDto.fromJson(_asJsonObject(response.data));
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String avatar,
  }) async {
    final response = await _dio.post<dynamic>(
      '/users/',
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'role': 'customer',
        'avatar': avatar,
      },
    );
    _asJsonObject(response.data);
  }

  @override
  Future<AuthUserDto> getProfile(String accessToken) async {
    final response = await _dio.get<dynamic>(
      '/auth/profile',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
        extra: {'redactAuthorization': true},
      ),
    );
    return AuthUserDto.fromJson(_asJsonObject(response.data));
  }

  @override
  Future<AuthTokensDto> refresh(String refreshToken) async {
    final response = await _dio.post<dynamic>(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );
    return AuthTokensDto.fromJson(_asJsonObject(response.data));
  }

  Map<String, dynamic> _asJsonObject(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const FormatException('Expected a JSON object from the server.');
  }
}
