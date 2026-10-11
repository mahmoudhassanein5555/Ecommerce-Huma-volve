import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/signup_req_model.dart';
import '../models/signup_res_model.dart';

class SignUpService {
  final ApiClient _apiClient;

  SignUpService({required this._apiClient});

  Future<SignupResModel> signUp(SignupReqModel signupModel) async {
    final response = await _apiClient.dio.post(
      ApiEndpoints.signUpEndpoint,
      data: {
        "email": signupModel.email,
        "name": signupModel.name,
        "password": signupModel.password,
        "avatar": "https://i.imgur.com/LDOO4Qs.jpg",
      },
    );
    final Map<String, dynamic> jsonData = response.data;
    return SignupResModel.fromJson(jsonData);
  }
}
