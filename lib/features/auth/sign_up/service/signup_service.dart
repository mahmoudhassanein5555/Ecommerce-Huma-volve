import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_manager.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/model/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/model/signup_response_model.dart';

class SignupService {
  ApiManager apiManager;

  SignupService(this.apiManager);

  Future<SignupResponseModel> signup(SignupReqModel signupReqModel) async {
    final response = await apiManager.dio.post(
      ApiEndPoints.signupEndpoint,
      data: {
        "email": signupReqModel.email,
        "password": signupReqModel.password,
        "name": signupReqModel.name,
        "avatar": "https://i.imgur.com/LDOO4Qs.jpg",
      },
    );
    final jsonData = response.data;
    final signupResponse = SignupResponseModel.fromJson(jsonData);
    return signupResponse;
  }
}
