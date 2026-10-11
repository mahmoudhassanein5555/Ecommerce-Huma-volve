import 'package:ecommerce_app_huma_volve/core/constants/api_endPoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signUp_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signUp_req_model.dart';

class SignupService {
  ApiClient apiClient;

  SignupService(this.apiClient);
  
  Future<SignUpResModel>signUp(SignupReqModel signupReqModel) async{
    
    final response =  await apiClient.dio.post(ApiEndpoints.signUpEndPoint,data: {
        "email": signupReqModel.email,
        "name": signupReqModel.name,
        "password": signupReqModel.password,
        "role": "customer",
        "avatar": "https://i.pravatar.cc/300"

    }) ;

    final modelData = SignUpResModel.fromJson(response.data);

    return modelData;
    

  }
}