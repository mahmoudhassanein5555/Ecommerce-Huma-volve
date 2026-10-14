import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/viewModel/sign_up_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit({required this.signUpUseCase}) : super(SignUpInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());

    final result = await signUpUseCase.invoke(
      name: name,
      email: email,
      password: password,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(SignUpError(failure.failureMessage)),
      (signupEntity) => emit(SignUpSuccess(signupEntity)),
    );
  }
}
