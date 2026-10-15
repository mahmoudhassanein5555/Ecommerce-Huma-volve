import '../../domain/entity/signup_entity.dart';

abstract class SignupStates {}

class SignupInitial extends SignupStates {}

class SignupLoading extends SignupStates {}

class SignupSuccess extends SignupStates {
  final SignupEntity signupEntity;
  SignupSuccess(this.signupEntity);
}

class SignupError extends SignupStates {
  final String errorMessage;
  SignupError(this.errorMessage);
}
