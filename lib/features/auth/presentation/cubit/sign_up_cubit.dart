import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_up_use_case.dart';

import 'sign_up_state.dart';


class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit(this.signUpUseCase) : super(SignUpInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());

    try {
      await signUpUseCase(
        name: name,
        email: email,
        password: password,
      );

      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }
}