import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.dio.post(
      ApiEndpoints.users,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://i.imgur.com/LDOO4Qs.jpg',
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.dio.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}