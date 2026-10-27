part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class LoginSuccess extends AuthState {
  final AuthSessionEntity session;

  const LoginSuccess(this.session);
}

final class SignUpSuccess extends AuthState {
  final AuthUserEntity user;

  const SignUpSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
