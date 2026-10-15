import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/app_exptions.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/refresh_token_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, void>> login(LoginRequest loginRequset) async {
    try {
      final loginResponse = await _remoteDataSource.login(loginRequset);
      await _localDataSource.saveAccessToken(loginResponse.accessToken);
      await _localDataSource.saveRefreshToken(loginResponse.refreshToken);
      return Right(null);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> register(
    RegisterRequest registerRequset,
  ) async {
    try {
      await _remoteDataSource.register(registerRequset);
      return Right(null);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return Left(Failure('Refresh token not found'));
      }
      final response = await _remoteDataSource.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );
      await _localDataSource.saveAccessToken(response.accessToken);
      await _localDataSource.saveRefreshToken(response.refreshToken);
      return Right(null);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
