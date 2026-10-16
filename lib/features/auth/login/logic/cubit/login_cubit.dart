import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/imports/common_imports.dart';
import '../../../../../features/auth/domain/use_cases/login_use_case.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(LoginInitial());

  final LoginUseCase _loginUseCase;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  Future<void> login() async {
    emit(LoginLoading());
    final response = await _loginUseCase(
      LoginRequestModel(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
    response.fold(
      (failure) {
        emit(LoginError(errorMessage: failure.displayMessage));
      },
      (result) async {
        await SharedPrefHelper.saveDataByKey(
          SharedPrefHelper.userTokenKey,
          result.accessToken,
        );
        emit(LoginSuccess());
      },
    );
  }
}
