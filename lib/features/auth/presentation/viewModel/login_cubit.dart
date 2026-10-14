import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/viewModel/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    final result = await loginUseCase.invoke(email: email, password: password);
    if (isClosed) return;

    result.fold(
      (failure) => emit(LoginError(failure.failureMessage)),
      (loginEntity) => emit(LoginSuccess(loginEntity)),
    );
  }
}
