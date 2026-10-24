import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      await loginUseCase(email: email, password: password);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    return error.toString();
  }
}
