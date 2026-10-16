
import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handel.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/datasource/signup_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entity/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/repository/signup_repo.dart';

class SignupRepoImp implements SignupRepo {
  final SignupDataSource signupDataSource;

  SignupRepoImp(this.signupDataSource);

  @override
  Future<Either<Failure, SignupEntity>> signup(
    SignupReqModel signupReqModel,
  ) async {
    try {
      final result = await signupDataSource.signup(signupReqModel);
      return Right(result);
    } on DioException catch (e) {
      return Left(ErrorHandel.handleError(e));
    } catch (e) {
      return Left(
        Failure(message: "An unexpected error occurred: ${e.toString()}"),
      );
    }
  }
}