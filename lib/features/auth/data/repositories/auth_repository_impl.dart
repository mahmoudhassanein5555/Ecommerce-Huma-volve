import '../../services/auth_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
final AuthService authService;

AuthRepositoryImpl(this.authService);

@override
Future<Map<String, dynamic>> login({
required String email,
required String password,
}) async {
return await authService.login(
email: email,
password: password,
);
}

@override
Future<Map<String, dynamic>> signUp({
required String name,
required String email,
required String password,
}) async {
return await authService.signUp(
name: name,
email: email,
password: password,
);
}
}
