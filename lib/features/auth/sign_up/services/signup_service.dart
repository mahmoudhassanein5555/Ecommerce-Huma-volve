import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/signup_res.dart';

class SignupService {
  ApiClient apiClient ;
  SignupService(this.apiClient);
    Future<SignupResModel> signup(SignupReqModel signupReqModel)async{
     final response=await apiClient.dio.post(
       ApiEndpoints.signupEndpoint,
       data: {
         "name": signupReqModel.name,
         "email": signupReqModel.email,
         "password": signupReqModel.password,
         "avatar":"https://api.lorem.space/image/face?w=640&h=480&r=867",
       }
     );

final jsonDAta=response.data;
     return SignupResModel.fromJson(jsonDAta);
   }
}


