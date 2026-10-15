import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> login(LoginRequest loginRequset);
  Future<Either<Failure, void>> register(RegisterRequest registerRequset);
  Future<Either<Failure, void>> refreshToken();
}
