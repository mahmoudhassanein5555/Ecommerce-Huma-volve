import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_res_model.dart';

class SignUpServices {

  ApiService apiservice;
  
  SignUpServices(this.apiservice);
  
  Future<SignUpResModel> signUp(SignUpReqModel signupReqModel) async {

    final response = await apiservice.dio.post(
      ApiConstants.signupEndpoint,
      data: {
        "email": signupReqModel.email,
        "name": signupReqModel.name,
        "password": signupReqModel.password,
        "avatar": "https://api.lorem.space/image/face?w=640&h=480"
      },
    );

    final jsonData = response.data;

    final dartData = SignUpResModel.fromJson(jsonData);
    
    return dartData;
  }
}
