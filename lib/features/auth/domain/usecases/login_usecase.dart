import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<String> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
