import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  // Access Token

  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: 'access_token',
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(
      key: 'access_token',
    );
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(
      key: 'access_token',
    );
  }

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();

    return token != null && token.isNotEmpty;
  }

  // Refresh Token

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: 'refresh_token',
      value: token,
    );
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: 'refresh_token',
    );
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(
      key: 'refresh_token',
    );
  }
}