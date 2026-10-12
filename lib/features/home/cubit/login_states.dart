
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String accessToken;

  LoginSuccess(this.accessToken);
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}

