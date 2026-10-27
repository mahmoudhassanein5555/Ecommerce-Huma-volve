import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  static final SecureStorageService _instance =
      SecureStorageService._internal();

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearAuthTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
