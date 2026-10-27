import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;

  AuthCubit({required this.loginUseCase, required this.signUpUseCase})
    : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await loginUseCase(email: email, password: password);
    result.when(
      success: (session) => emit(LoginSuccess(session)),
      failure: (message) => emit(AuthFailure(message)),
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await signUpUseCase(
      name: name,
      email: email,
      password: password,
    );
    result.when(
      success: (user) => emit(SignUpSuccess(user)),
      failure: (message) => emit(AuthFailure(message)),
    );
  }
}
