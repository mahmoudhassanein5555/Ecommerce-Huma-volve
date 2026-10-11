import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  // Singleton Pattern
  static final SecureStorageHelper instance = SecureStorageHelper.internal();
  factory SecureStorageHelper() => instance;
  SecureStorageHelper.internal();

  final storage = const FlutterSecureStorage();

  // Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String expiresAtKey = 'expires_at';

  // Save tokens
  Future<void> saveAccessToken(String token) async {
    await storage.write(key: accessTokenKey, value: token);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await storage.write(key: accessTokenKey, value: accessToken);
    await storage.write(key: refreshTokenKey, value: refreshToken);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await storage.read(key: accessTokenKey);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey);
  }

  // Get expires at
  Future<String?> getExpiresAt() async {
    return await storage.read(key: expiresAtKey);
  }

  // Clear all tokens (Logout)
  Future<void> clearTokens() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
    await storage.delete(key: expiresAtKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
