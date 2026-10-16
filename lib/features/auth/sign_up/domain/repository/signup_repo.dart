import 'package:dart_either/dart_either.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entity/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';


abstract class SignupRepo {
  Future<Either<Failure, SignupEntity>> signup(SignupReqModel signupReqModel);
}