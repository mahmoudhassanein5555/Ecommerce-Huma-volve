part of 'signup_cubit.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

// signup
final class SignupLoading extends AuthState {}

final class SignupSuccess extends AuthState {
  final SignupResEntity signupResEntity;

  SignupSuccess(this.signupResEntity);
}

final class SignupError extends AuthState {
  final String errorMessage;

  SignupError(this.errorMessage);
}

// login
final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {
  final LoginEntity loginEntity;

  LoginSuccess(this.loginEntity);
}

final class LoginError extends AuthState {
  final String errorMessage;

  LoginError(this.errorMessage);
}
