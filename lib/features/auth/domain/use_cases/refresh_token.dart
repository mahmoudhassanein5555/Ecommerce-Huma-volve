import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class RefreshToken {
  final AuthRepo _authRepo;
  RefreshToken(this._authRepo);

  Future<Either<Failure, void>> call() async {
    return await _authRepo.refreshToken();
  }
}
