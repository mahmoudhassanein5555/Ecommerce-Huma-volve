import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_tokens_dto.dart';

abstract interface class AuthLocalDataSource {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> saveTokens(AuthTokensDto tokens);
  Future<void> clearTokens();
}

class SecureAuthLocalDataSource implements AuthLocalDataSource {
  SecureAuthLocalDataSource({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> saveTokens(AuthTokensDto tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
