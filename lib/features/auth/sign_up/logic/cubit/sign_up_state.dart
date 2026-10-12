part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

class SignUpSuccess extends SignUpState {
  // final LoginResponseModel responseModel;

  // LoginSuccess({required this.responseModel});
}

class SignUpLoading extends SignUpState {}

class SignUpError extends SignUpState {
  final String errorMessage;

  SignUpError({required this.errorMessage});
}
