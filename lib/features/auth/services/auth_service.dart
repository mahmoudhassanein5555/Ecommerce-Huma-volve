import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/users',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://i.imgur.com/LDOO4Qs.jpg',
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}