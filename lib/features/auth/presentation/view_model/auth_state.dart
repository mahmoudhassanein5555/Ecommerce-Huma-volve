part of "auth_cubit.dart";

sealed class AuthState {}

class InitialState extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final Failure failure;
  AuthFailure({required this.failure});
}
