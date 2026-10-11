import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class Register {
  final AuthRepo _authRepo;
  Register(this._authRepo);
  Future<Either<Failer, void>> call({
    required RegisterRequest registerRequest,
  }) async {
    return await _authRepo.register(registerRequest);
  }
}
