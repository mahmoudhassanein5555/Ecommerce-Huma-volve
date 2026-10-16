import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/login_model.dart';
import '../services/login_service.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginService loginService;

  LoginCubit(this.loginService) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final loginModel = LoginModel(
        email: email,
        password: password,
      );

      final response = await loginService.login(loginModel);
      final data = response.data;

      if (data is Map && data['access_token'] != null) {
        emit(
          LoginSuccess(
            data['access_token'].toString(),
          ),
        );
      } else {
        
        emit(
          LoginError(
            'Login response did not contain an access token.',
          ),
        );
      }
    } catch (e) {
      

      emit(
        LoginError(
          'Login failed. Please check your email and password.',
        ),
      );
    }
  }
}
