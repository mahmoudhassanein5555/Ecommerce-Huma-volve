import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;

  SignupCubit(this.signupUseCase) : super(SignupInitialState());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignupLoadingState());
    final result = await signupUseCase.invoke(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(SignupFailureState(failure.failureMessage)),
      (_) => emit(SignupSuccessState()),
    );
  }
}
