import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthEntity> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
