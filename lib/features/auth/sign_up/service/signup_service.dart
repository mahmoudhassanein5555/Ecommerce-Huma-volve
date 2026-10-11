import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../model/signup_model.dart';

class SignupServices {
  ApiClient apiClient;
  SignupServices({required this.apiClient});
  Future<SignupModel> signup(String email, String password, String name) async {
    final response = await apiClient.dio.post(
      ApiEndPoints.signupEndpoint,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
      },
    );
    Map<String, dynamic> data = response.data;
    SignupModel signupModel = SignupModel.fromJson(data);
    return signupModel;
  }
}
