import '../../core/di/service_locator.dart';
import 'presentation/cubit/auth_cubit.dart';

class AuthFactory {
  const AuthFactory._();

  static AuthCubit createCubit() {
    return getIt<AuthCubit>();
  }
}
