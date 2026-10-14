import '../../../../core/services/api_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  @override
  Future<String> login({
    required String email,
    required String password,
  }) {
    return _apiService.login(email: email, password: password);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _apiService.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
