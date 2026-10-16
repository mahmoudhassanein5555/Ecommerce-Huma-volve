import 'package:ecommerce_app_huma_volve/features/auth/login/domain/entity/login_entity.dart';

abstract class LoginState{}
final class LoginInitialState extends LoginState{}
final class LoginLoadingState extends LoginState{}
final class LoginSuccessState extends LoginState{
  final LoginEntity loginEntity;
  LoginSuccessState(this.loginEntity);
}
final class LoginErrorState extends LoginState{
  final String errorMessage;
  LoginErrorState(this.errorMessage);
}