import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_res_model.dart';

class SignupService {
  ApiClient apiClient;

  SignupService(this.apiClient);

  Future<SignupResModel> signUp(SignupReqModel signUpRecModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "email": signUpRecModel.email.trim(),
        "name": signUpRecModel.name.trim(),
        "password": signUpRecModel.password,
        "avatar": "https://api.loren.space/image/face?w=&h=480",
      },
    );
    return SignupResModel.fromJson(response.data);
  }
}
