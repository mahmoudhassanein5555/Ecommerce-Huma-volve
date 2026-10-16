import 'package:bloc/bloc.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUpUseCase) : super(SignUpInitial());

  final SignUpUseCase _signUpUseCase;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  Future<void> signup() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    emit(SignUpLoading());
    final response = await _signUpUseCase(
      SignUpRequestModel(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      ),
    );
    response.fold(
      (failure) {
        emit(SignUpError(errorMessage: failure.displayMessage));
      },
      (result) async {
        // await saveUserToken(result.token);
        emit(SignUpSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    return super.close();
  }
}
