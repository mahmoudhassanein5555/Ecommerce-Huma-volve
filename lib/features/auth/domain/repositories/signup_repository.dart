import '../entities/signup_entity.dart';

abstract class SignupRepository {
  Future<SignupEntity> signup({
    required String name,
    required String email,
    required String password,
  });
}
