import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/sign_up_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequestModel request) async {
    try {
      final loginResponseModel = await remoteDataSource.login(request);
      final loginResponse = _toLoginResponseEntity(loginResponseModel);
      return right(loginResponse);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }
      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }

  @override
  Future<Either<Failure, SignUpResponse>> signUp(SignUpRequestModel request) async {
    try {
      final signUpResponseModel = await remoteDataSource.signUp(request);
      final signUpResponse = _toSignUpResponseEntity(signUpResponseModel);
      return right(signUpResponse);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }
      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }

  LoginResponse _toLoginResponseEntity(LoginResponseModel model) {
    return LoginResponse(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
  }

  SignUpResponse _toSignUpResponseEntity(SignUpResponseModel model) {
    return SignUpResponse(
      id: model.id,
      email: model.email,
      name: model.name,
      role: model.role,
      avatar: model.avatar,
      password: model.password,
      creationAt: model.creationAt,
      updatedAt: model.updatedAt,
    );
  }
}
