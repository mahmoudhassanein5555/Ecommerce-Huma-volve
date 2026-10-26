import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitialState());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    final result = await loginUseCase.invoke(email: email, password: password);
    result.fold(
      (failure) => emit(LoginFailureState(failure.failureMessage)),
      (_) => emit(LoginSuccessState()),
    );
  }
}
