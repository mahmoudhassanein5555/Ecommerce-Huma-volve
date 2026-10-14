import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_entity.dart';

abstract class SignUpStates {}

class SignUpInitial extends SignUpStates {}

class SignUpLoading extends SignUpStates {}

class SignUpSuccess extends SignUpStates {
  final SignupEntity signupEntity;

  SignUpSuccess(this.signupEntity);
}

class SignUpError extends SignUpStates {
  final String errorMessage;

  SignUpError(this.errorMessage);
}
