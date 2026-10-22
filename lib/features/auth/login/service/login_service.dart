import '../../../../core/Network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/login_model.dart';

class LoginService{
  ApiClient apiClient ;
  LoginService(this.apiClient);
  Future<LoginModel> login({
    required String email,
    required String password,
  })async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": email, "password":password},
    );
    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);

    return modelData ;
  }
}