import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repos/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo authRepo;

  SignUpUseCase(this.authRepo);

  Future<ApiResult<AuthUserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return authRepo.signUp(name: name, email: email, password: password);
  }
}
