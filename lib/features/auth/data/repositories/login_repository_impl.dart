import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';

import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../data_sources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginEntity> login({required String email, required String password}) async {
    final loginModel = await remoteDataSource.login(email: email, password: password);

    await SecureStorage.saveAccessToken(loginModel.accessToken);

    await SecureStorage.saveRefreshToken(loginModel.refreshToken);

    return LoginEntity(
      accessToken: loginModel.accessToken,
      refreshToken: loginModel.refreshToken,
    );
  }
}
