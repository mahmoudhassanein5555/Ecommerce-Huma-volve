import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';

class CheckSessionUseCase {
  final AuthRepository authRepository;

  CheckSessionUseCase(this.authRepository);

  Future<Either<Failure, bool>> invoke() => authRepository.isLoggedIn();
}
