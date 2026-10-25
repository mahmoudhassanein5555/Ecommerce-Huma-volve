import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_session_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepo {
  Future<ApiResult<AuthSessionEntity>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthUserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });
}
