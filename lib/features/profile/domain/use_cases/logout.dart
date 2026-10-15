import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class Logout {
  final ProfileRepo _profileRepo;
  Logout(this._profileRepo);

  Future<Either<Failure, void>> call() async {
    return await _profileRepo.logout();
  }
}
