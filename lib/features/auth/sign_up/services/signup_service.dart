import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../model/signup_req_model.dart';
import '../model/signup_res_model.dart';

class SignupService {
  ApiClient apiClient;
  SignupService(this.apiClient);
  Future<SignupResModel> signUp(SignupReqModel signupReqModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "name": signupReqModel.name,
        "email": signupReqModel.email,
        "password": signupReqModel.password,
        "avatar": "https://api.lorem.space/image/face?w=640&h=480",
      },
    );
    final jsonData = response.data;
    final dartData = SignupResModel.fromJson(jsonData);

    return dartData;
  }
}