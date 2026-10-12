import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_res_model.dart';

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