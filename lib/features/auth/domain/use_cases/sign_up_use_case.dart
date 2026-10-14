import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';

import '../entities/signup_entity.dart';

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  Future<Either<Failure, SignupEntity>> invoke({
    required String name,
    required String email,
    required String password,
  }) => authRepository.signUp(name: name, email: email, password: password);
}
