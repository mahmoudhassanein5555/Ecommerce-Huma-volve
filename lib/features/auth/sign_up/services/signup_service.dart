import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_manager.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';

import '../models/signup_res_Model.dart';

class SignupService {
  ApiManager apiManager;
  SignupService(this.apiManager);
Future<SignupResModel> signUp({
required SignupReqModel signupReqMod,
}) async {
    final response = await apiManager.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "email": signupReqMod.email,
        "name": signupReqMod.name,
        "password": signupReqMod.password,
        "role": "customer",
        "avatar": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzQndkZZ-WcX_3UQ1-kwDeJsMizaTI_b5AD0U4xkAUHg&s=10",
      },
    );
    final jsonData = response.data;
    final modelData = SignupResModel.fromJson(jsonData);
    return modelData;
  }
}
