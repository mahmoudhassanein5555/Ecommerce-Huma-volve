import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({required String email, required String password});

  Future<SignupModel> signUp({
    required String name,
    required String email,
    required String password,
  });
}
