import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_clint.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/model/signup_model.dart';

class SignupService {
  ApiClint apiClint;
  SignupService(this.apiClint);
  
  Future<SignupModel>signUp({required String email,required String name, required String password}) async{
   final response = await  apiClint.dio.post(ApiEndpoints.signupEndPoint,

        data:
        {
          "email": email,
          "name": name,
          "password": password,
          "avatar": "https://th.bing.com/th?id=OIF.pH%2fHYilEnIVlhcKxLZ5%2beg&r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3"
        }

        );
    final modelData = SignupModel.fromJson(response.data);

    return modelData;

    
  }
  
}