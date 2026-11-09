import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../model/token_model.dart';
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<TokenModel> signIn({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  new({required this.apiClient});
  @override
  Future<TokenModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndPoint,
      data: {"email": email, "password": password},
    );

    return TokenModel.fromJson(response.data);
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signUpEndpoint,
      data: {
        "name": name,
        "email": email,
        "password": password,
        "avatar": ApiConstants.defaultAvatarUrl,
      },
    );

    return UserModel.fromJson(response.data);
  }
}
