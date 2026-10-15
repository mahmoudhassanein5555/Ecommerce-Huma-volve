import 'package:ecommerce_app_huma_volve/features/auth/Domain/use_case/post_login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/use_case/post_sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Presentation/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  PostLoginUseCase postLoginUseCase;
  PostSignUpUseCase postSignUpUseCase;
  AuthCubit({required this.postLoginUseCase, required this.postSignUpUseCase})
    : super(AuthInitialState());

  Future<void> Login({required String email, required String password}) async {
    emit(LoginLoadingState());
    final LoginData = await postLoginUseCase.execute(email, password);
    LoginData.fold(
      (failure) {
        emit(LoginErrorState(failure.FailureMessage));
      },
      (data) {
        emit(LoginSuccessState(data));
      },
    );
  }

  Future<void> SignUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoadingState());
    final signUpdata = await postSignUpUseCase.execute(email, password, name);
    signUpdata.fold(
      (failure) {
        emit(SignUpErrorState(failure.FailureMessage));
      },
      (data) {
        emit(SignUpSuccessState(data));
      },
    );
  }
}
