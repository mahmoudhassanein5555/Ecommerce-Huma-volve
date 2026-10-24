import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_clint.dart';

import '../models/login_model.dart';

class LoginService {
  ApiClint apiClint ;
  LoginService(this.apiClint);

   Future<LoginModel> login({required String email,required String password} ) async{
    final response =  await apiClint.dio.post(
        ApiEndpoints.loginEndPoint,
        data:
        {
          "email":email,
          "password": password
        }
        );

    final modelData = LoginModel.fromJson(response.data);



    return modelData;



  }
}