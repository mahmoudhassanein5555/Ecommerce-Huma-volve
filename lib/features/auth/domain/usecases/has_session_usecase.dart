import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/failure/failure.dart';

class HasSessionUsecase {
  final AuthRepository authRepository;
  HasSessionUsecase({required this.authRepository});

  Future<Either<Failure, bool>> invoke() async {
    return await authRepository.hasSession();
  }
}
