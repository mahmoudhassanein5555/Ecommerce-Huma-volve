
import '../../sign_up/models/signUp_req_models.dart';
import '../../sign_up/models/signup_res_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class signupServices{
  ApiClient apiClient;
  signupServices(this.apiClient);
 Future<SignupResModels> signup(SignupReqModels signupReqModels) async {
final response= await apiClient.dio.post(ApiEndpoints.sighupEndpoints , data:{
  "name": signupReqModels.name,
  "email":signupReqModels.email,
  "password": signupReqModels.password,
  "avatar": "https://picsum.photos/200"
});
final jsonData= response.data;
final dartData=SignupResModels.fromJson(jsonData);
return dartData;
  }
}