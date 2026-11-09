import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repository/auth_repository.dart';

class SignInUsecase {
  final AuthRepository authRepository;

  SignInUsecase({required this.authRepository});

  Future<Either<Failure, Unit>> invoke({
    required String email,
    required String password,
  }) async {
    return await authRepository.signIn(email: email, password: password);
  }
}
