import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._secureStorageService);

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    final entity = model.toEntity();
    await _secureStorageService.saveAuthTokens(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
    );
    return entity;
  }
}
