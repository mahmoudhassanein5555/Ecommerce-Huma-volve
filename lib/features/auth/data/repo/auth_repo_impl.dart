import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/secure_storage_helper.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({required this._apiConsumer, SecureStorageHelper? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageHelper.instance;

  final ApiConsumer _apiConsumer;
  final SecureStorageHelper _secureStorage;

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String avatar,
  }) async {
    final response = await _apiConsumer.post(
      AppEndPoints.createUser,
      data: {
        'email': email,
        'name': name,
        'password': password,
        'role': 'customer',
        'avatar': avatar,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const FormatException('Unexpected sign-up response from server.');
    }
    return UserModel.fromJson(response);
  }

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiConsumer.post(
      AppEndPoints.login,
      data: {'email': email, 'password': password},
    );

    if (response is! Map<String, dynamic>) {
      throw const FormatException('Unexpected login response from server.');
    }

    final tokens = AuthTokensModel.fromJson(response);
    await _secureStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    return tokens;
  }
}
