import '../repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
