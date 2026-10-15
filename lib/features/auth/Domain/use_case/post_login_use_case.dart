import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/login_entities.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/repository/auth_repository.dart';

class PostLoginUseCase {
  AuthRepository authRepository;
  PostLoginUseCase(this.authRepository);
  Future<Either<Failure, LoginEntities>> execute(
    String email,
    String password,
  ) {
    return authRepository.Login(email, password);
  }
}
