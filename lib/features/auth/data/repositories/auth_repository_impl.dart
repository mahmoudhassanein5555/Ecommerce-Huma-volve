import 'package:dio/dio.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_tokens_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remote = remoteDataSource,
       _local = localDataSource;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await _remote.login(email, password);
      await _local.saveTokens(tokens);
      try {
        return await _getProfileWithTokens(tokens);
      } on AuthFailure {
        await _local.clearTokens();
        rethrow;
      }
    } on DioException catch (error) {
      throw _mapDioError(error, invalidCredentials: true);
    } on FormatException {
      throw const AuthFailure(
        'The server returned an invalid response.',
        AuthFailureKind.invalidResponse,
      );
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String avatar,
  }) async {
    try {
      await _remote.register(
        name: name,
        email: email,
        password: password,
        avatar: avatar,
      );
    } on DioException catch (error) {
      throw _mapDioError(error, registration: true);
    } on FormatException {
      throw const AuthFailure(
        'The server returned an invalid response.',
        AuthFailureKind.invalidResponse,
      );
    }
  }

  @override
  Future<AuthUser> getProfile() async {
    final accessToken = await _local.readAccessToken();
    final refreshToken = await _local.readRefreshToken();
    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      throw const AuthFailure(
        'Please log in to continue.',
        AuthFailureKind.unauthorized,
      );
    }

    var tokens = AuthTokensDto(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
    );
    if (tokens.accessToken.isEmpty) {
      tokens = await _refreshForSession(tokens.refreshToken);
    }

    try {
      return (await _remote.getProfile(tokens.accessToken)).toEntity();
    } on DioException catch (error) {
      if (error.response?.statusCode != 401) {
        throw _mapDioError(error);
      }
    } on FormatException {
      throw const AuthFailure(
        'The server returned an invalid response.',
        AuthFailureKind.invalidResponse,
      );
    }

    if (tokens.refreshToken.isEmpty) {
      await _local.clearTokens();
      throw const AuthFailure(
        'Your session expired. Please log in again.',
        AuthFailureKind.unauthorized,
      );
    }
    tokens = await _refreshForSession(tokens.refreshToken);
    try {
      return (await _remote.getProfile(tokens.accessToken)).toEntity();
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _local.clearTokens();
        throw const AuthFailure(
          'Your session expired. Please log in again.',
          AuthFailureKind.unauthorized,
        );
      }
      throw _mapDioError(error);
    } on FormatException {
      throw const AuthFailure(
        'The server returned an invalid response.',
        AuthFailureKind.invalidResponse,
      );
    }
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final accessToken = await _local.readAccessToken();
    final refreshToken = await _local.readRefreshToken();
    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      return null;
    }
    try {
      return await getProfile();
    } on AuthFailure catch (failure) {
      if (failure.kind == AuthFailureKind.unauthorized) return null;
      rethrow;
    }
  }

  @override
  Future<void> logout() => _local.clearTokens();

  Future<AuthUser> _getProfileWithTokens(AuthTokensDto tokens) async {
    try {
      return (await _remote.getProfile(tokens.accessToken)).toEntity();
    } on DioException catch (error) {
      throw _mapDioError(error);
    } on FormatException {
      throw const AuthFailure(
        'The server returned an invalid response.',
        AuthFailureKind.invalidResponse,
      );
    }
  }

  Future<AuthTokensDto> _refreshForSession(String refreshToken) async {
    try {
      final tokens = await _remote.refresh(refreshToken);
      await _local.saveTokens(tokens);
      return tokens;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null &&
          statusCode < 500 &&
          statusCode != 429) {
        await _local.clearTokens();
        throw const AuthFailure(
          'Your session expired. Please log in again.',
          AuthFailureKind.unauthorized,
        );
      }
      throw _mapDioError(error);
    } on FormatException {
      await _local.clearTokens();
      throw const AuthFailure(
        'The server returned an invalid response.',
        AuthFailureKind.invalidResponse,
      );
    }
  }

  AuthFailure _mapDioError(
    DioException error, {
    bool invalidCredentials = false,
    bool registration = false,
  }) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      final isTimeout =
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout;
      return AuthFailure(
        isTimeout
            ? 'The request timed out. Please try again.'
            : 'Unable to connect. Check your internet connection and try again.',
        AuthFailureKind.network,
      );
    }

    final statusCode = error.response?.statusCode;
    if (invalidCredentials && (statusCode == 401 || statusCode == 400)) {
      return const AuthFailure(
        'Email or password is incorrect.',
        AuthFailureKind.invalidCredentials,
      );
    }
    if (registration &&
        (statusCode == 400 || statusCode == 409 || statusCode == 422)) {
      return const AuthFailure(
        'This account could not be created. Check the details or use another email.',
        AuthFailureKind.unknown,
      );
    }
    if (statusCode == 401 || statusCode == 403) {
      return const AuthFailure(
        'Your session is no longer valid. Please log in.',
        AuthFailureKind.unauthorized,
      );
    }
    if (statusCode == 429) {
      return const AuthFailure(
        'Too many requests. Please try again later.',
        AuthFailureKind.server,
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return const AuthFailure(
        'The server is temporarily unavailable.',
        AuthFailureKind.server,
      );
    }
    return const AuthFailure(
      'Something went wrong. Please try again.',
      AuthFailureKind.unknown,
    );
  }
}
