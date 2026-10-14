import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

import '../../../core/network/api_client.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }
}

class AuthException implements Exception {
  const AuthException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({ApiClient? apiClient, FlutterSecureStorage? storage})
    : _apiClient = apiClient ?? ApiClient(),
      _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _defaultAvatar = 'https://i.imgur.com/LDOO4Qs.jpg';

  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _apiClient.dio.post(
        '/users',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'avatar': _defaultAvatar,
        },
      );
    } on DioException catch (error) {
      throw _toAuthException(error);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );
      final data = response.data;
      if (data is! Map || data['access_token'] is! String) {
        throw const AuthException(
          'The server returned an invalid login response.',
        );
      }

      final accessToken = data['access_token'] as String;
      if (accessToken.isEmpty) {
        throw const AuthException('The server returned an empty access token.');
      }

      await _saveAccessToken(accessToken);
    } on DioException catch (error) {
      throw _toAuthException(error);
    }
  }

  Future<AuthUser> getProfile({String? accessToken}) async {
    final token = accessToken ?? await _readAccessToken();
    if (token == null || token.isEmpty) {
      throw const AuthException('No saved login session was found.');
    }

    try {
      final response = await _apiClient.dio.get(
        '/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AuthException(
          'The server returned an invalid profile response.',
        );
      }

      return AuthUser.fromJson(data);
    } on DioException catch (error) {
      throw _toAuthException(error);
    }
  }

  Future<AuthUser?> restoreSession() async {
    final token = await _readAccessToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await getProfile(accessToken: token);
    } on AuthException catch (error) {
      if (error.statusCode == 401) {
        await logout();
        return null;
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _accessTokenKey);
    } on PlatformException catch (error) {
      throw AuthException(
        'Unable to clear the saved login session: '
        '${error.message ?? 'secure storage failed'}',
      );
    }
  }

  Future<String?> _readAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } on PlatformException catch (error) {
      throw AuthException(
        'Unable to read the saved login session: '
        '${error.message ?? 'secure storage failed'}',
      );
    }
  }

  Future<void> _saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } on PlatformException catch (error) {
      throw AuthException(
        'Unable to save the login session securely: '
        '${error.message ?? 'secure storage failed'}',
      );
    }
  }

  AuthException _toAuthException(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return AuthException(
        'Email or password is incorrect, or your session has expired.',
        statusCode: statusCode,
      );
    }
    if (statusCode == 409) {
      return AuthException(
        'An account with this email already exists.',
        statusCode: statusCode,
      );
    }

    final responseData = error.response?.data;
    final message = responseData is Map ? responseData['message'] : null;
    final serverMessage = switch (message) {
      String value => value,
      List values => values.whereType<String>().join('\n'),
      _ => null,
    };

    if (serverMessage != null && serverMessage.isNotEmpty) {
      return AuthException(serverMessage, statusCode: statusCode);
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AuthException(
        'Could not connect to the server. Check your internet connection.',
        statusCode: statusCode,
      );
    }

    return AuthException(
      'Authentication failed. Please try again.',
      statusCode: statusCode,
    );
  }
}

final authService = AuthService();
