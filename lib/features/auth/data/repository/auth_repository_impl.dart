import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  @override
  Future<Either<Failure, bool>> hasSession() async {
    try {
      final access = await tokenStorage.getAccessToken();
      return right(access != null);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final token = await remote.signIn(email: email, password: password);
      await tokenStorage.saveTokens(
        access: token.accessToken,
        refresh: token.refreshToken,
      );
      return right(unit);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<void> signOut() async {
    await tokenStorage.deleteTokens();
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.signUp(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
