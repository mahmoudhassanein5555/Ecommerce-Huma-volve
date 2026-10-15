import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/app_exptions.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/data_source/local/profile_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/user_entity.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  ProfileRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final token = await _localDataSource.getAccessToken();
      final profileResponse = await _remoteDataSource.getProfile(token);
      final userEntity = UserEntity(
        id: profileResponse.id,
        email: profileResponse.email,
        name: profileResponse.name,
        role: profileResponse.role,
        avatar: profileResponse.avatar,
        creationAt: profileResponse.creationAt,
        updatedAt: profileResponse.updatedAt,
      );
      return Right(userEntity);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearTokens();
      return const Right(null);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
