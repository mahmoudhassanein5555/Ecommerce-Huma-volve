import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser> login({required String email, required String password});
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String avatar,
  });
  Future<AuthUser> getProfile();
  Future<AuthUser?> restoreSession();
  Future<void> logout();
}
