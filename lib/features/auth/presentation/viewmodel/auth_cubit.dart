import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/usecases/has_session_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final HasSessionUsecase hasSessionUsecase;
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;
  final SignOutUsecase signOutUsecase;

  AuthCubit({
    required this.hasSessionUsecase,
    required this.signInUsecase,
    required this.signUpUsecase,
    required this.signOutUsecase,
  }) : super(InitialState());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await signUpUsecase.invoke(
      name: name,
      email: email,
      password: password,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(AuthFailure(failure: failure)),
      (result) => emit(AuthSuccess()),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await signInUsecase.invoke(email: email, password: password);
    if (isClosed) return;

    result.fold(
      (failure) => emit(AuthFailure(failure: failure)),
      (result) => emit(Authenticated()),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    await signOutUsecase.invoke();
    if (isClosed) return;

    emit(Unauthenticated());
  }

  Future<void> checkAuthStatus() async {
    final hasSession = await hasSessionUsecase.invoke();
    if (isClosed) return;

    hasSession.fold((failure) {
      emit(AuthFailure(failure: failure));
      emit(Unauthenticated());
    }, (hasSession) => emit(hasSession ? Authenticated() : Unauthenticated()));
  }
}
