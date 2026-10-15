import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_case/signup_use_case.dart';
import 'signup_states.dart';

class SignupCubit extends Cubit<SignupStates> {
  final SignupUseCase signupUseCase;
  SignupCubit(this.signupUseCase) : super(SignupInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());

    final result = await signupUseCase.invoke(
      name: name,
      email: email,
      password: password,
    );
    if (isClosed) return;

    result.fold(
          (failure) => emit(SignupError(failure.failureMessage)),
          (signupEntity) => emit(SignupSuccess(signupEntity)),
    );
  }
}
