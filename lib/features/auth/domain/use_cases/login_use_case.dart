import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Failure, LoginEntity>> invoke({
    required String email,
    required String password,
  }) {
    return authRepository.login(email: email, password: password);
  }
}
