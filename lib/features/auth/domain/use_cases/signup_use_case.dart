import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  Future<Either<Failure, SignupEntity>> invoke({
    required String name,
    required String email,
    required String password,
  }) {
    return authRepository.signUp(name: name, email: email, password: password);
  }
}
