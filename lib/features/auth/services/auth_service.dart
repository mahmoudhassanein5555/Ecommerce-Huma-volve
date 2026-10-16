import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_service.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage_service.dart';

class AuthService {
  final ApiService apiService = ApiService();

  final SecureStorageService secureStorageService =
      SecureStorageService();

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.dio.post(
        'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = Map<String, dynamic>.from(response.data);

      // Save Access Token
      final accessToken = data['access_token'];

      if (accessToken is String && accessToken.isNotEmpty) {
        await secureStorageService.saveAccessToken(accessToken);
      }

      // Save Refresh Token if provided by the API
      final refreshToken = data['refresh_token'];

      if (refreshToken is String && refreshToken.isNotEmpty) {
        await secureStorageService.saveRefreshToken(refreshToken);
      }

      return data;
    } on DioException catch (e) {
      final responseData = e.response?.data;

      final message = responseData is Map
          ? responseData['message']
          : null;

      throw Exception(
        message ?? 'Login failed',
      );
    }
  }

  // Sign Up
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.dio.post(
        'users/',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'avatar': 'https://picsum.photos/800',
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      final message = responseData is Map
          ? responseData['message']
          : null;

      throw Exception(
        message ?? 'Sign up failed',
      );
    }
  }
}