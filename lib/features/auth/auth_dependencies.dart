import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_service.dart';
import 'api/auth_api_service.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_use_case.dart';


class AuthDependencies {
  AuthDependencies._();

  static LoginUseCase buildLoginUseCase() {
    final authApiService = AuthApiService(ApiClient());
    final remoteDataSource = AuthRemoteDataSourceImpl(authApiService);
    final repository = AuthRepositoryImpl(
      remoteDataSource,
      SecureStorageService(),
    );
    return LoginUseCase(repository);
  }
}
