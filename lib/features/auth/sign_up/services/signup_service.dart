import 'package:ecommerce_app_huma_volve/core/constants/api_endpioints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_reqeust_model.dart';

class SignupService {
  ApiClient apiClient;
  SignupService(this.apiClient);
  Future<SignUpModel> signup(SignupReqeustModel requestModel) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpioints.signupEndpoint,
        data: {
          'name': requestModel.name,
          'email': requestModel.email,
          'password': requestModel.password,
          'avatar': 'https://api.lorem.space/image/face?w=640&h=480&r=867',
        },
      );
      final data = response.data;
      final modelData = SignUpModel.fromJson(data);
      return modelData;
    } catch (e) {
      rethrow;
    }
  }
}