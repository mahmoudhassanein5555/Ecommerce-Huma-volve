import 'package:ecommerce_app_huma_volve/core/errors/app_exception.dart';
import 'package:ecommerce_app_huma_volve/core/storage/token_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/models/auth_tokens_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/models/sign_up_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/models/user_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_huma_volve/features/auth/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory fake so the provider is tested without network calls.
class FakeAuthService implements AuthService {
  bool failLogin = false;
  bool signUpCalled = false;

  static const _user = UserModel(
    id: 1,
    name: 'Mona',
    email: 'mona@mail.com',
    avatar: '',
    role: 'customer',
  );

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    if (failLogin) {
      throw const AppException('Incorrect email or password.', statusCode: 401);
    }
    return const AuthTokensModel(accessToken: 'token', refreshToken: 'refresh');
  }

  @override
  Future<UserModel> signUp(SignUpRequestModel request) async {
    signUpCalled = true;
    return _user;
  }

  @override
  Future<UserModel> getProfile() async => _user;
}

void main() {
  late FakeAuthService service;
  late TokenStorage storage;
  late AuthProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    service = FakeAuthService();
    storage = await TokenStorage.init();
    provider = AuthProvider(service, storage);
  });

  test('login success saves token and loads user', () async {
    final error = await provider.login(email: 'mona@mail.com', password: '123456');

    expect(error, isNull);
    expect(storage.accessToken, 'token');
    expect(provider.user?.name, 'Mona');
    expect(provider.isLoading, isFalse);
  });

  test('login failure returns message and saves nothing', () async {
    service.failLogin = true;

    final error = await provider.login(email: 'mona@mail.com', password: 'bad');

    expect(error, 'Incorrect email or password.');
    expect(storage.hasToken, isFalse);
    expect(provider.isLoading, isFalse);
  });

  test('sign up creates account then logs in', () async {
    final error = await provider.signUp(
      name: 'Mona',
      email: 'mona@mail.com',
      password: '123456',
    );

    expect(error, isNull);
    expect(service.signUpCalled, isTrue);
    expect(storage.hasToken, isTrue);
  });

  test('logout clears token and user', () async {
    await provider.login(email: 'mona@mail.com', password: '123456');
    await provider.logout();

    expect(storage.hasToken, isFalse);
    expect(provider.user, isNull);
  });

  test('sign up request always includes the required avatar', () {
    const request = SignUpRequestModel(
      name: ' Mona ',
      email: 'mona@mail.com',
      password: '123456',
    );
    expect(request.toJson()['avatar'], isNotEmpty);
    expect(request.toJson()['name'], 'Mona');
  });
}
