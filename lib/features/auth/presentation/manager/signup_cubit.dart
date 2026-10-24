import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/signup_usecase.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;

  SignupCubit(this.signupUseCase) : super(SignupInitial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());

    try {
      await signupUseCase(name: name, email: email, password: password);

      emit(SignupSuccess());
    } catch (error) {
      emit(SignupFailure(_mapError(error)));
    }
  }

  String _mapError(Object error) {
    return error.toString();
  }
}
