import '../models/login_model.dart';
import '../models/signup_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({required String email, required String password});

  Future<SignupModel> signUp({
    required String name,
    required String email,
    required String password,
  });
}
