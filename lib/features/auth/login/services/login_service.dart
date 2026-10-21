import '../../../../core/Network/api_manager.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../model/login_model.dart';

class LoginService {
  ApiManager apiManager;
  LoginService(this.apiManager);
  login( String email, String password) async {
     final response= await apiManager.dio.post(ApiEndpoints.loginEndPoint,data:{
       'email':email,
       'password':password,
     });
     final Map<String,dynamic> jsonData=response.data;
     final modelData= LoginModel.fromJson(jsonData);
     return modelData;
     }
}
