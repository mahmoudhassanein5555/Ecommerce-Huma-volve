import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final storage = FlutterSecureStorage();
  static Future saveAccessToken(String token) async {
    await storage.write(key: 'access_token', value: token);
  }

  static Future saveRefreshToken(String token) async {
    await storage.write(key: 'refresh_token', value: token);
  }

  static Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  static Future<void> deleteTonkens() async {
    await storage.deleteAll();
  }
}
