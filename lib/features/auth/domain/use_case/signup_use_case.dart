import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entity/signup_entity.dart';
import '../repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;
  SignupUseCase(this.authRepository);

  Future<Either<Failure, SignupEntity>> invoke({
    required String name,
    required String email,
    required String password,
  }) => authRepository.signUp(name: name, email: email, password: password);
}
