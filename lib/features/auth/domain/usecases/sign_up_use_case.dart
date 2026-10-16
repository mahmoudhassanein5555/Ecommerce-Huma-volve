import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}