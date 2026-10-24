import '../entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> login({required String email, required String password});
}
