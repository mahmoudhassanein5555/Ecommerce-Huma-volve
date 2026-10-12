import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_tokens.dart';
import '../models/auth_user.dart';

abstract interface class AuthTokenStorage {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> save(AuthTokens tokens);
  Future<void> clear();
}

class SecureAuthTokenStorage implements AuthTokenStorage {
  SecureAuthTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> save(AuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({Dio? dio, AuthTokenStorage? tokenStorage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.escuelajs.co/api/v1',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: const {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          ),
      _tokenStorage = tokenStorage ?? SecureAuthTokenStorage();

  static final instance = AuthService();

  final Dio _dio;
  final AuthTokenStorage _tokenStorage;

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );
      final tokens = AuthTokens.fromJson(_asJsonObject(response.data));
      await _tokenStorage.save(tokens);

      try {
        return await getProfile();
      } catch (_) {
        await _tokenStorage.clear();
        rethrow;
      }
    } on DioException catch (error) {
      throw _toAuthException(error, invalidCredentials: true);
    } on FormatException {
      throw const AuthException('The server returned an invalid response.');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String avatar,
  }) async {
    try {
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
    } on DioException catch (error) {
      throw _toAuthException(error, registration: true);
    } on FormatException {
      throw const AuthException('The server returned an invalid response.');
    }
  }

  Future<AuthUser> getProfile() async {
    var accessToken = await _tokenStorage.readAccessToken();
    var refreshToken = await _tokenStorage.readRefreshToken();

    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      throw const AuthException('Please log in to continue.');
    }

    if (accessToken == null || accessToken.isEmpty) {
      final tokens = await _refreshForSession(refreshToken!);
      accessToken = tokens.accessToken;
      refreshToken = tokens.refreshToken;
    }

    try {
      return await _fetchProfile(accessToken);
    } on DioException catch (error) {
      if (error.response?.statusCode != 401) {
        throw _toAuthException(error);
      }
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clear();
      throw const AuthException('Your session expired. Please log in again.');
    }

    final tokens = await _refreshForSession(refreshToken);
    try {
      return await _fetchProfile(tokens.accessToken);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _tokenStorage.clear();
        throw const AuthException('Your session expired. Please log in again.');
      }
      throw _toAuthException(error);
    }
  }

  Future<AuthUser?> restoreSession() async {
    final accessToken = await _tokenStorage.readAccessToken();
    final refreshToken = await _tokenStorage.readRefreshToken();
    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      return null;
    }

    try {
      return await getProfile();
    } on AuthException {
      return null;
    }
  }

  Future<void> logout() => _tokenStorage.clear();

  Future<AuthTokens> _refresh(String refreshToken) async {
    final response = await _dio.post<dynamic>(
      '/auth/refresh-token',
      data: {'refreshToken': refreshToken},
    );
    final tokens = AuthTokens.fromJson(_asJsonObject(response.data));
    await _tokenStorage.save(tokens);
    return tokens;
  }

  Future<AuthTokens> _refreshForSession(String refreshToken) async {
    try {
      return await _refresh(refreshToken);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == null || statusCode == 429 || statusCode >= 500) {
        throw _toAuthException(error);
      }
      await _tokenStorage.clear();
      throw const AuthException('Your session expired. Please log in again.');
    } on FormatException {
      await _tokenStorage.clear();
      throw const AuthException('The server returned an invalid response.');
    }
  }

  Future<AuthUser> _fetchProfile(String accessToken) async {
    final response = await _dio.get<dynamic>(
      '/auth/profile',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return AuthUser.fromJson(_asJsonObject(response.data));
  }

  Map<String, dynamic> _asJsonObject(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const FormatException('Expected a JSON object from the server.');
  }

  AuthException _toAuthException(
    DioException error, {
    bool invalidCredentials = false,
    bool registration = false,
  }) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const AuthException('The request timed out. Please try again.');
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return const AuthException(
        'Unable to connect. Check your internet connection and try again.',
      );
    }

    final statusCode = error.response?.statusCode;
    if (invalidCredentials && (statusCode == 401 || statusCode == 400)) {
      return const AuthException('Email or password is incorrect.');
    }
    if (registration &&
        (statusCode == 400 || statusCode == 409 || statusCode == 422)) {
      return const AuthException(
        'This account could not be created. Check the details or use another email.',
      );
    }
    if (statusCode == 401 || statusCode == 403) {
      return const AuthException(
        'Your session is no longer valid. Please log in.',
      );
    }
    if (statusCode == 429) {
      return const AuthException('Too many requests. Please try again later.');
    }
    if (statusCode != null && statusCode >= 500) {
      return const AuthException('The server is temporarily unavailable.');
    }
    return const AuthException('Something went wrong. Please try again.');
  }
}
