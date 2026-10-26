import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImp(this.authRemoteDataSource);

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final login = await authRemoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(login);
    } catch (error) {
      return Left(ErrorHandling.handle(error));
    }
  }

  @override
  Future<Either<Failure, SignupEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final signup = await authRemoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return Right(signup);
    } catch (error) {
      return Left(ErrorHandling.handle(error));
    }
  }
}
