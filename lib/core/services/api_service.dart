
import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';

class ApiService {
  ApiService({
    Dio? dio,
    SecureStorageService? secureStorage,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.escuelajs.co/api/v1',
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            ),
        _secureStorage = secureStorage ?? SecureStorageService();

  final Dio _dio;
  final SecureStorageService _secureStorage;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final data = response.data;
      if (data is! Map || data['access_token'] is! String) {
        throw Exception('Invalid login response from server.');
      }

      final token = data['access_token'] as String;
      await _secureStorage.saveToken(token);
      return token;
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/users/',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'avatar': 'https://i.imgur.com/LDOO4Qs.jpg',
        },
      );
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      if (response.data is! List) {
        throw Exception('Invalid products response from server.');
      }
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<String?> getSavedToken() {
    return _secureStorage.getToken();
  }

  Future<void> logout() {
    return _secureStorage.deleteToken();
  }

  String _getErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Connection problem. Check your internet and try again.';
    }

    if (statusCode == 401) {
      return 'Invalid email or password.';
    }

    if (statusCode == 400 || statusCode == 409) {
      return 'Please check the information you entered.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Server error. Please try again later.';
    }

    return 'Something went wrong. Please try again.';
  }
}
