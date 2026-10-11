import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRepo {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String avatar,
  });

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });
}