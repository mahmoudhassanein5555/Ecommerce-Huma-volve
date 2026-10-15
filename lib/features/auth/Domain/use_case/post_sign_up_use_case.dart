import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/sign_up_entities.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/repository/auth_repository.dart';

class PostSignUpUseCase {
  final AuthRepository authRepository;
  PostSignUpUseCase(this.authRepository);
  Future<Either<Failure, SignUpEntities>> execute(
    String email,
    String password,
    String name,
  ) {
    return authRepository.SingUp(email, password, name);
  }
}
