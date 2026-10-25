import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_session_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repos/auth_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/usecases/login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeAuthRepo repository;
  late AuthCubit cubit;

  setUp(() {
    repository = _FakeAuthRepo();
    cubit = AuthCubit(
      loginUseCase: LoginUseCase(repository),
      signUpUseCase: SignUpUseCase(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('login emits loading then success', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<LoginSuccess>()]),
    );

    await cubit.login(email: 'user@example.com', password: 'secret1');
    await expectation;
  });

  test('sign-up emits loading then failure', () async {
    repository.signUpResult = const ApiResult.failure('Email already exists');
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthFailure>()]),
    );

    await cubit.signUp(
      name: 'Test User',
      email: 'user@example.com',
      password: 'secret1',
    );
    await expectation;
  });
}

class _FakeAuthRepo implements AuthRepo {
  ApiResult<AuthSessionEntity> loginResult = const ApiResult.success(
    AuthSessionEntity(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    ),
  );

  ApiResult<AuthUserEntity> signUpResult = const ApiResult.success(
    AuthUserEntity(
      id: 1,
      email: 'user@example.com',
      name: 'Test User',
      role: 'customer',
      avatar: null,
      creationAt: null,
      updatedAt: null,
    ),
  );

  @override
  Future<ApiResult<AuthSessionEntity>> login({
    required String email,
    required String password,
  }) async {
    return loginResult;
  }

  @override
  Future<ApiResult<AuthUserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return signUpResult;
  }
}
