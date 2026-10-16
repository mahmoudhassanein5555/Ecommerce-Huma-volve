import 'package:dart_either/src/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handel.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/core/storage_services/storage_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/login_datasource.dart';

import 'package:ecommerce_app_huma_volve/features/auth/login/domain/entity/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/repository/login_repo.dart';

class LoginRepoImp implements LoginRepository {
  final LoginDatasource loginDataSource;

  LoginRepoImp(this.loginDataSource);

  @override
  Future<Either<Failure, LoginEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final loginResponse = await loginDataSource.login(email, password);
      await StorageServices.saveAccessToken(loginResponse.accessToken ?? '');
      await StorageServices.saveRefreshToken(loginResponse.refreshToken ?? '');
      return Right(loginResponse);
    } on DioException catch (e) {
      return Left(ErrorHandel.handleError(e));
    } catch (e) {
      return Left(Failure(message: "Something went wrong: ${e.toString()}"));
    }
  }
}
