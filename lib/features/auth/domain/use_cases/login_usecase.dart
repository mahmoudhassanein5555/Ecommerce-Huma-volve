import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/login_repo.dart';

class LoginUsecase {
  final LoginRepo repo;
  LoginUsecase(this.repo);

  Future<Either<Failure, LoginEntity>> call({
    required String email,
    required String password,
  }) => repo.login(email: email, password: password);
}
