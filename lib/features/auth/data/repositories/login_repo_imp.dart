import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/login_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/login_repo.dart';

class LoginRepoImp implements LoginRepo {
  final LoginDatasource loginDatasource;

  LoginRepoImp(this.loginDatasource);

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await loginDatasource.login(
        email: email,
        password: password,
      );

      return Right(result.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
