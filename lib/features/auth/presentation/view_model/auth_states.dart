abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  final String errorMessage;

  LoginFailureState(this.errorMessage);
}

abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {}

class SignupFailureState extends SignupState {
  final String errorMessage;

  SignupFailureState(this.errorMessage);
}
