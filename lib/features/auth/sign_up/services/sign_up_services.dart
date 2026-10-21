import 'package:ecommerce_app_huma_volve/features/auth/sign_up/model/sign_up_res_model.dart';

import '../../../../core/Network/api_manager.dart';
import '../../../../core/constants/api_endpoints.dart';

class SignUpServices {
  ApiManager apiManager;
  SignUpServices(this.apiManager);
  Future<SignUpResModel> signup(
    String email,
    String password,
    String name,
  ) async {
    final response = await apiManager.dio.post(
      ApiEndpoints.signupEndPoint,
      data: {
        "email": email,
        "name": name,
        "password": password,
        "avatar": "https://i.imgur.com/LDOO4Qs.jpg",
      },
    );
    final jsonData = response.data;
    final dartData = SignUpResModel.fromJson(jsonData);
    return dartData;
  }
}
