import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entity/login_entity.dart';
import '../entity/signup_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, SignupEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });
}
