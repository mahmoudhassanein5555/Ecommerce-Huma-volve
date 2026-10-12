import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_response.dart';

class AuthRepo {
  final ApiServices apiServices;

  AuthRepo(this.apiServices);

  Future<Either<Failure, LoginResponse>> login(
    LoginRequest requestModel,
  ) async {
    try {
      final response = await apiServices.login(requestModel);

      return right(response);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }

      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }

  Future<Either<Failure, SignUpResponse>> signUp(
    SignUpRequest requestModel,
  ) async {
    try {
      final response = await apiServices.signUp(requestModel);

      return right(response);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }

      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }
}
