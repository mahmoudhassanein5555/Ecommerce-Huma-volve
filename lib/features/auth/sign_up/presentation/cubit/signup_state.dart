import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entity/signup_entity.dart';

abstract class SignupState {}

final class SignupInitialState extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupSuccessState extends SignupState {
  final SignupEntity message;

  SignupSuccessState(this.message);
}

final class SignupErrorState extends SignupState {
  final String message;

  SignupErrorState(this.message);
}