
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/entity/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitialState());

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    final result = await loginUseCase(email, password);
    result.fold(
      ifLeft: (Failure value) {
        emit(LoginErrorState(value.message));
      },
      ifRight: (LoginEntity value) {
        emit(LoginSuccessState(value));
      },
    );
  }
}