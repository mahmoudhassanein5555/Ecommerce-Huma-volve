abstract class AuthRepository {
  Future<String> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}
