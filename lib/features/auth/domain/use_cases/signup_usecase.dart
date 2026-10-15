import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_req_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_res_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/signup_repo.dart';

class SignupUsecase {
  final SignupRepo signupRepo;

  SignupUsecase(this.signupRepo);

  Future<Either<Failure, SignupResEntity>> call(
    SignupReqEntity signupReqEntity,
  ) => signupRepo.signup(signupReqEntity);
}
