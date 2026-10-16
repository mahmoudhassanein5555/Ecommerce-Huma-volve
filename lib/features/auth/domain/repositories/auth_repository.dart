import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/sign_up_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequestModel request);
  Future<Either<Failure, SignUpResponse>> signUp(SignUpRequestModel request);
}
