import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/login_entities.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/entities/sign_up_entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignUpEntities>> SingUp(
    String email,
    String password,
    String name,
  );
  Future<Either<Failure, LoginEntities>> Login(String email, String password);
}
