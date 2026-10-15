import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/login_entities.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/sign_up_entities.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  LoginEntities loginEntities;
  LoginSuccessState(this.loginEntities);
}

class SignUpLoadingState extends AuthState {}

class SignUpSuccessState extends AuthState {
  SignUpEntities loginEntities;
  SignUpSuccessState(this.loginEntities);
}

class LoginErrorState extends AuthState {
  final errorMessage;
  LoginErrorState(this.errorMessage);
}

class SignUpErrorState extends AuthState {
  final errorMessage;
  SignUpErrorState(this.errorMessage);
}
