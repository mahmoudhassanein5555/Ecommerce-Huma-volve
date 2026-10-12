import 'package:ecommerce_app_huma_volve/core/network/dio_client.dart';

class Authservice {
  Future<String> Login({
    required String email,
    required String password,
  }) async {
    final response = await DioClint.dio.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );
    return response.data['access_token'];
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await DioClint.dio.post(
      "/users",
      data: {
        "name": name,
        "email": email,
        "password": password,
        "role": "customer",
        "avatar": "https://api.lorem.space/image/face?w=640&h=480&r=867",
      },
    );
  }
}
