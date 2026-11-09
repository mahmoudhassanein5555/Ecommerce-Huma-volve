import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository authRepository;
  SignUpUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> invoke({
    required String name,
    required String email,
    required String password,
  }) async {
    return await authRepository.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
