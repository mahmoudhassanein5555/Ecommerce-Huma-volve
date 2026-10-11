import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_model.dart';

class LoginService {
  final ApiClient _apiClient;

  LoginService({required this._apiClient});

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.dio.post(
      ApiEndpoints.loginEndPoint,
      data: {"email": email, "password": password},
    );

    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);

    return modelData;
  }
}
