import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_req_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_res_entity.dart';

abstract class SignupRepo {
  Future<Either<Failure, SignupResEntity>> signup(
    SignupReqEntity signupReqEntity,
  );
}
