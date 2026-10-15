import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_model.dart';
import '../models/signup_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImp(this.apiClient);

  static const String _defaultAvatar =
      "https://api.lorem.space/image/face?w=640&h=480";

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {"email": email, "password": password},
    );
    return LoginModel.fromJson(response.data);
  }

  @override
  Future<SignupModel> signUp({
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
        "avatar": _defaultAvatar,
      },
    );
    return SignupModel.fromJson(response.data);
  }
}
