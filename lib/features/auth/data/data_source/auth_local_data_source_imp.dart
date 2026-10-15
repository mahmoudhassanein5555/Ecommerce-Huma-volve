import '../../../../core/storage/secure_storage.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImp implements AuthLocalDataSource {
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await SecureStorage.saveAccessToken(accessToken);
    await SecureStorage.saveRefreshToken(refreshToken);
  }
}
