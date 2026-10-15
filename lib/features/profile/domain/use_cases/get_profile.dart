import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/user_entity.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetProfile {
  final ProfileRepo _profileRepo;
  GetProfile(this._profileRepo);

  Future<Either<Failure, UserEntity>> call() async {
    return await _profileRepo.getProfile();
  }
}
