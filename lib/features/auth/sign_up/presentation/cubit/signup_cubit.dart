
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/usecase/signup_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/presentation/cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;

  SignupCubit(this.signupUseCase) : super(SignupInitialState());

  Future<void> signup(SignupReqModel signupReqModel) async {
    emit(SignupLoadingState());
    final result = await signupUseCase(signupReqModel);
    result.fold(
      ifLeft: (failure) {
        emit(SignupErrorState(failure.message));
      },
      ifRight: (signupEntity) {
        emit(SignupSuccessState(signupEntity));
      },
    );
  }
}