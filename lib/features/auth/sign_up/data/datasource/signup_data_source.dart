

import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_res_model.dart';

abstract class SignupDataSource {

  Future<SignupResModel> signup(SignupReqModel signupReqModel);
}