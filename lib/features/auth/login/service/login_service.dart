import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../model/login_model.dart';

class LoginServices {
  ApiClient apiclient;
  LoginServices({required this.apiclient});

  Future<LoginModel> login(String email, String password) async {
    final response = await apiclient.dio.post(
      ApiEndPoints.loginEndpoint,
      data: {"email": email, "password": password},
    );
    Map<String, dynamic> data = response.data;
    LoginModel loginModel = LoginModel.fromJson(data);
    return loginModel;
  }
}
