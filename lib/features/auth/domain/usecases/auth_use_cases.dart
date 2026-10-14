import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  const AuthUseCases(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> login({
    required String email,
    required String password,
  }) => _repository.login(email: email, password: password);

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String avatar,
  }) => _repository.register(
    name: name,
    email: email,
    password: password,
    avatar: avatar,
  );

  Future<AuthUser> getProfile() => _repository.getProfile();

  Future<AuthUser?> restoreSession() => _repository.restoreSession();

  Future<void> logout() => _repository.logout();
}
