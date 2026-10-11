import 'package:ecommerce_app_huma_volve/core/consts/cached_keys.dart';
import 'package:ecommerce_app_huma_volve/core/errors/local_exptions.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthLocalDataSource)
class AuthSecureStorageDataSource implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthSecureStorageDataSource(this._secureStorage);

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(key: CachedKeys.accessToken, value: token);
    } catch (e) {
      throw LocalExptions('Failed to save access token');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: CachedKeys.refreshToken, value: token);
    } catch (e) {
      throw LocalExptions('Failed to save refresh token');
    }
  }
}
