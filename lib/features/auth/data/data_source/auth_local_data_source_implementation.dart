import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/auth_local_data_source.dart';


class AuthLocalDataSourceImplementation implements AuthLocalDataSource {
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await SecureStorage.saveAccessToken(accessToken);
    await SecureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<String?> getAccessToken() => SecureStorage.getAccessToken();

  @override
  Future<String?> getRefreshToken() => SecureStorage.getRefreshToken();

  @override
  Future<void> clearTokens() => SecureStorage.deleteTokens();
}
