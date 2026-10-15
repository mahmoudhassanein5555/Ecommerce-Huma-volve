import 'package:ecommerce_app_huma_volve/core/consts/cached_keys.dart';
import 'package:ecommerce_app_huma_volve/core/errors/local_exptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileLocalDataSource {
  Future<String> getAccessToken();
  Future<void> clearTokens();
}

@Singleton(as: ProfileLocalDataSource)
class ProfileSecureStorageDataSource implements ProfileLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  ProfileSecureStorageDataSource(this._secureStorage);

  @override
  Future<String> getAccessToken() async {
    try {
      final token = await _secureStorage.read(key: CachedKeys.accessToken);
      if (token == null) throw LocalExptions('Access token not found');
      return token;
    } catch (e) {
      throw LocalExptions('Failed to read access token');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: CachedKeys.accessToken);
      await _secureStorage.delete(key: CachedKeys.refreshToken);
    } catch (e) {
      throw LocalExptions('Failed to clear tokens');
    }
  }
}
