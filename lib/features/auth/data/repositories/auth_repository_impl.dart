import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final accessToken = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    final profile = await _remoteDataSource.fetchProfile(accessToken);
    return AuthSession(
      user: AuthUserModel.fromJson(profile),
      accessToken: accessToken,
    );
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );
    return AuthUserModel.fromJson(user);
  }
}
