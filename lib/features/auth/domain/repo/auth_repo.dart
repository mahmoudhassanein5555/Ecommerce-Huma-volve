import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';
import 'package:injectable/injectable.dart';
@singleton
abstract class AuthRepo {
  Future<Either<Failer, void>> login(LoginRequest loginRequset);
  Future<Either<Failer, void>> register(RegisterRequest registerRequset);
}
