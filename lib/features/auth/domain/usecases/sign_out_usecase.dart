import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository authRepository;
  SignOutUsecase({required this.authRepository});

  Future<void> invoke() async {
    return await authRepository.signOut();
  }
}
