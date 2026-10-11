import 'package:ecommerce_app_huma_volve/core/constant/api_endpoint.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_re_model.dart';

class SignUpService {
  ApiClient apiClient;
  SignUpService(this.apiClient);
  Future<SignUpModel> signup(SignupReModel signupModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoint.signUpEndPoint,
      data: {
        "name": signupModel.name,
        "email": signupModel.email,
        "password": signupModel.password,
        "avatar":
            "https://avatarfiles.alphacoders.com/368/thumb-150-368375.png",
      },
    );
    final Map<String, dynamic> json = response.data;
    final modelData = SignUpModel.fromJson(json);

    return modelData;
  }
}
