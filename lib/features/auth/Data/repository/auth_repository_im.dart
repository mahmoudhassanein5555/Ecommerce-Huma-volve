import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/data_source/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/model/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/model/sign_up_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/login_entities.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/sign_up_entities.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/repository/auth_repository.dart';

class AuthRepositoryIm extends AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryIm(this.authRemoteDataSource);
  @override
  Future<Either<Failure, LoginEntities>> Login(
    String email,
    String password,
  ) async {
    try {
      final result = await authRemoteDataSource.Login(email, password);

      final data = ModelToEntitiesLogin(result);
      await SecureStorage.saveAccessToken(data.accessToken!);
      await SecureStorage.saveRefreshToken(data.refreshToken!);
      return Right(data);
    } catch (e) {
      return Left(ErrorHandling.handleError(e));
    }
  }

  @override
  Future<Either<Failure, SignUpEntities>> SingUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      final Response = await authRemoteDataSource.SingUp(email, password, name);
      final data = ModelToEntitiesSignUp(Response);
      return Right(data);
    } catch (e) {
      return Left(ErrorHandling.handleError(e));
    }
  }

  LoginEntities ModelToEntitiesLogin(LoginModel loginModel) {
    return LoginEntities(
      accessToken: loginModel.accessToken,
      refreshToken: loginModel.refreshToken,
    );
  }

  SignUpEntities ModelToEntitiesSignUp(SignUpModel signUpModel) {
    return SignUpEntities(
      email: signUpModel.email,
      password: signUpModel.password,
      name: signUpModel.name,
      imageUrl: signUpModel.imageUrl,
      id: signUpModel.id,
      role: signUpModel.role,
      creationAt: signUpModel.creationAt,
      updatedAt: signUpModel.updatedAt,
    );
  }
}
