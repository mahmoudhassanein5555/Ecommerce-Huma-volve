import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handiling.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/signup_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, SignupEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
