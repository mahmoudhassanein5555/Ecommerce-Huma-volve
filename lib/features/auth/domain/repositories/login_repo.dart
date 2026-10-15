import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';

abstract class LoginRepo {
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  });
}
