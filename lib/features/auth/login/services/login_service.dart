import '../../../../core/Network/api_manager.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/storage/secure_storage.dart';
import '../model/login_model.dart';

class LoginService {
  final ApiManager apiManager;
  final SecureStorage _secureStorage = SecureStorage();

  LoginService(this.apiManager);

  login(String email, String password) async {
    final response = await apiManager.dio.post(
      ApiEndpoints.loginEndPoint,
      data: {'email': email, 'password': password},
    );

    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);

    await _secureStorage.saveAccessToken(modelData.accessToken ?? "");
    await _secureStorage.saveRefreshToken(modelData.refreshToken ?? "");

    return modelData;
  }
}
