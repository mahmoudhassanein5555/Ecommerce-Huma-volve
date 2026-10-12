import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Keys Constants
  static const String userTokenKey = 'USER_SECURE_TOKEN';

  static Future<void> writeSecureData({
    required String key,
    required String value,
  }) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> readSecureData({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> deleteSecureData({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }
}
