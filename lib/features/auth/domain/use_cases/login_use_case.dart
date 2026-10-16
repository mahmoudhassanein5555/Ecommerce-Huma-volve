import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/login_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponse>> call(LoginRequestModel request) {
    return repository.login(request);
  }
}
