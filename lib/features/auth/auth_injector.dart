import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/auth_local_data_source_implementation.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/auth_remote_data_source_implementation.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repository/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/check_session_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/viewModel/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/viewModel/sign_up_cubit.dart';


class AuthInjector {
  AuthInjector._();

  static AuthRepository _repository() => AuthRepositoryImplementation(
    AuthRemoteDataSourceImplementation(ApiClient()),
    AuthLocalDataSourceImplementation(),
  );

  static LoginCubit loginCubit() =>
      LoginCubit(loginUseCase: LoginUseCase(_repository()));

  static SignUpCubit signUpCubit() =>
      SignUpCubit(signUpUseCase: SignUpUseCase(_repository()));

  static CheckSessionUseCase checkSessionUseCase() =>
      CheckSessionUseCase(_repository());

  static LogoutUseCase logoutUseCase() => LogoutUseCase(_repository());
}
