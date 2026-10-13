abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}