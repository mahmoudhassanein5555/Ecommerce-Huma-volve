import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_responce.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/refresh_token_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_responce.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest loginRequset);
  Future<RegisterResponse> register(RegisterRequest registerRequset);
  Future<LoginResponse> refreshToken(RefreshTokenRequest request);
}
