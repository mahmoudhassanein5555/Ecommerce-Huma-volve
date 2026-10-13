import '../../domain/entity/login_entity.dart';

abstract class LoginStates {}

class LoginInitial extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginSuccess extends LoginStates {
  final LoginEntity loginEntity;
  LoginSuccess(this.loginEntity);
}

class LoginError extends LoginStates {
  final String errorMessage;
  LoginError(this.errorMessage);
}
