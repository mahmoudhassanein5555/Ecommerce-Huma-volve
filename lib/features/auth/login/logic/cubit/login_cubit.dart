import 'package:bloc/bloc.dart';
import 'package:ecommerce_app_huma_volve/core/local_database/shared_prefs_helper.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(LoginInitial());

  final AuthRepo _authRepo;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  login() async {
    emit(LoginLoading());
    final response = await _authRepo.login(
      LoginRequest(
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
