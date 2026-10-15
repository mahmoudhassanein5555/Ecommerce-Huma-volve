import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class Login {
  final AuthRepo _authRepo;
  Login(this._authRepo);
  Future<Either<Failure, void>> call({
    required LoginRequest loginRequest,
  }) async {
    return await _authRepo.login(loginRequest);
  }
}
