import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';



class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }
}