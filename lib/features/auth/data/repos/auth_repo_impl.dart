import 'package:ecommerce_app_huma_volve/core/network/api_call.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_session_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepoImpl(this.authRemoteDataSource);

  @override
  Future<ApiResult<AuthSessionEntity>> login({
    required String email,
    required String password,
  }) {
    return apiCall(() async {
      final session = await authRemoteDataSource.login(
        email: email,
        password: password,
      );
      return AuthSessionEntity(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
    });
  }

  @override
  Future<ApiResult<AuthUserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return apiCall(() async {
      final user = await authRemoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return AuthUserEntity(
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        avatar: user.avatar,
        creationAt: user.creationAt,
        updatedAt: user.updatedAt,
      );
    });
  }
}
