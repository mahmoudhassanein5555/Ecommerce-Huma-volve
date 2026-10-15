import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entity/login_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  LoginUseCase(this.authRepository);

  Future<Either<Failure, LoginEntity>> invoke({
    required String email,
    required String password,
  }) => authRepository.login(email: email, password: password);
}
