import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_response.dart';

class SignupService {
  final ApiClient apiClient;
  SignupService(this.apiClient);
  Future<SignupResponse> signUp(SignupRequest signupRequest) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "email": signupRequest.email,
        "name": signupRequest.name,
        "password": signupRequest.password,
        "avatar": "https://api.lorem.space/image/face?w=640&h=480",
      },
    );
    return SignupResponse.fromJson(response.data);
  }
}
