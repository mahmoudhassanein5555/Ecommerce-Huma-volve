import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.createDio();

  final Dio _dio;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final token = response.data?['access_token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('The store returned an invalid login token.');
    }
    return token;
  }

  Future<Map<String, dynamic>> fetchProfile(String accessToken) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/profile',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final profile = response.data;
    if (profile == null) {
      throw const FormatException('The store returned no user profile.');
    }
    return profile;
  }

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/users',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://picsum.photos/150',
      },
    );
    final user = response.data;
    if (user == null) {
      throw const FormatException('The store returned no new user.');
    }
    return user;
  }
}
