import 'package:ecommerce_app_huma_volve/core/constant/api_andpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network%20services/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/model/signup_res_model.dart';


class SignupService {
  NetworkServices networkServices;

  SignupService({required this.networkServices});

  Future<SignupResModel> signup(SignupResModel signupReqModel) async {
    final response = await networkServices.dio.post(
      ApiAndpoints.register,
      data: {
        'name': signupReqModel.name,
        'email': signupReqModel.email,
        'password': signupReqModel.password,
        "avatar": "https://png.pngtree.com/png-vector/20240413/ourmid/pngtree-cartoon-rabbit-eating-icon-image-png-image_12285856.png",
      },
    );
    final jsonResponse = response.data;
    final signupResModel = SignupResModel.fromJson(jsonResponse);
    return signupResModel;
  }
}