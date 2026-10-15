import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/cubit/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<AuthState> {
  LoginCubit(this.loginUsecase) : super(AuthInitial());
  final LoginUsecase loginUsecase;

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final result = await loginUsecase.call(email: email, password: password);
    result.fold(
      (failure) => emit(LoginError(failure.failureMessage)),
      (success) => emit(LoginSuccess(success)),
    );
  }
}
