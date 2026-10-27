import 'package:ecommerce_app_huma_volve/core/network/api_clint.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/screens/models/login_model.dart';

class LoginServices {
  final Apiclient apiclient;

  LoginServices(this.apiclient);

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiclient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {
        'email': email,
        'password': password,
      },
    );

    final Map<String, dynamic> jsonData =
        Map<String, dynamic>.from(response.data);
        final modelData = LoginModel.fromJson(jsonData);
        await SecureStorage.saveAccesstoken(modelData.accessToken);
        await SecureStorage.Saverefreshtoken(modelData.refreshToken);
        return modelData;



  }
}