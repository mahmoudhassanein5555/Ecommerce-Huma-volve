import '../../core/network/api_client.dart';
import 'data/data_source/auth_local_data_source_imp.dart';
import 'data/data_source/auth_remote_data_source_imp.dart';
import 'data/repository/auth_repository_imp.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/use_case/login_use_case.dart';
import 'domain/use_case/signup_use_case.dart';
import 'presentation/view_model/login_cubit.dart';
import 'presentation/view_model/signup_cubit.dart';

class AuthInjection {
  AuthInjection._();

  static AuthRepository _repository() => AuthRepositoryImp(
    remoteDataSource: AuthRemoteDataSourceImp(ApiClient()),
    localDataSource: AuthLocalDataSourceImp(),
  );

  static LoginCubit loginCubit() => LoginCubit(LoginUseCase(_repository()));

  static SignupCubit signupCubit() => SignupCubit(SignupUseCase(_repository()));
}
