import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/services/login_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/services/sign_up_service.dart';

class AuthRemoteDataSource {
  final LoginService loginService;
  final SignUpService signUpService;

  AuthRemoteDataSource({
    required this.loginService,
    required this.signUpService,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) {
    return loginService.login(
      body: LoginRequest(email: email, password: password),
    );
  }

  Future<SignUpResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return signUpService.signUp(
      body: SignUpRequest(name: name, email: email, password: password),
    );
  }
}
