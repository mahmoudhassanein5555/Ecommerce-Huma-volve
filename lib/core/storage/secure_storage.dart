import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String? token) async {
    if (token == null) return;
    await storage.write(key: 'accessToken', value: token);
  }

  Future<void> saveRefreshToken(String? token) async {
    if (token == null) return;
    await storage.write(key: 'refreshToken', value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  // logout
  Future<void> deleteTokens() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }
}
