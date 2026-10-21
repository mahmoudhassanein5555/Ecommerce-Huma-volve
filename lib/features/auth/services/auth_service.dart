import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/network/api_client.dart';
import '../models/auth_tokens_model.dart';
import '../models/sign_up_request_model.dart';
import '../models/user_model.dart';

/// Auth data source: HTTP calls + JSON → models.
/// Every failure is rethrown as an [AppException] via [ErrorHandler].
class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email.trim(), 'password': password},
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<UserModel> signUp(SignUpRequestModel request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.signUp,
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Requires a saved access token (added by the ApiClient interceptor).
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
