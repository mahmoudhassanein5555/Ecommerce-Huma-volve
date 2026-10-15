import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_req_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_res_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/signup_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class SignupCubit extends Cubit<AuthState> {
  SignupCubit(this.signupUsecase) : super(AuthInitial());
  final SignupUsecase signupUsecase;

  Future<void> signup(SignupReqEntity signupReqEntity) async {
    emit(SignupLoading());
    final result = await signupUsecase.call(signupReqEntity);
    result.fold(
      (failure) => emit(SignupError(failure.failureMessage)),
      (success) => emit(SignupSuccess(success)),
    );
  }
}
