import '../../../../core/Network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../model/sign_up model.dart';

class SignUpService {
  ApiClient apiClient;
  SignUpService(this.apiClient);

  Future<SignUpModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "name": name,
        "email": email,
        "password": password,
      },
    );

    final Map<String, dynamic> jsonData = response.data;
    final modelData = SignUpModel.fromJson(jsonData);

    return modelData;
  }
}
