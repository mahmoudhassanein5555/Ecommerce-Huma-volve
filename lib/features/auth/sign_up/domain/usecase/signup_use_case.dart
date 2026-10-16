
import 'package:dart_either/dart_either.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entity/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/repository/signup_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';

class SignupUseCase {
  SignupRepo signupRepo;

  SignupUseCase(this.signupRepo);

  Future<Either<Failure, SignupEntity>> call(
    SignupReqModel signupReqModel,
  ) async {
    return await signupRepo.signup(signupReqModel);
  }
}