import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/signup_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_req_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_res_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/signup_repo.dart';

class SignupRepoImp implements SignupRepo {
  final SignupDatasource signupDatasource;
  SignupRepoImp(this.signupDatasource);

  @override
  Future<Either<Failure, SignupResEntity>> signup(
    SignupReqEntity signupReqEntity,
  ) async {
    try {
      final result = await signupDatasource.signup(
        SignupReqModel.fromEntity(signupReqEntity),
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
