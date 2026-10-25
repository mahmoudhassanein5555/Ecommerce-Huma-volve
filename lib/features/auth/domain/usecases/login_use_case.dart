import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_session_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase(this.authRepo);

  Future<ApiResult<AuthSessionEntity>> call({
    required String email,
    required String password,
  }) {
    return authRepo.login(email: email, password: password);
  }
}
