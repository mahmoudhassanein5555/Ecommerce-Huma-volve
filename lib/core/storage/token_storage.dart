import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _accessToken = "access_token";
  static const String _refreshToken = "refresh_token";
  final storage = FlutterSecureStorage();

  Future<void> saveTokens({required String access, String? refresh}) async {
    await storage.write(key: _accessToken, value: access);
    await storage.write(key: _refreshToken, value: refresh);
  }

  Future<String?> getAccessToken() async => storage.read(key: _accessToken);
  Future<String?> getRefreshToken() async => storage.read(key: _refreshToken);

  Future<void> deleteTokens() async {
    await storage.delete(key: _accessToken);
    await storage.delete(key: _refreshToken);
  }
}
