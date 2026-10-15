import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_res_model.dart';

abstract class SignupDatasource {
  Future<SignupResModel> signup(SignupReqModel signupReqModel);
}
