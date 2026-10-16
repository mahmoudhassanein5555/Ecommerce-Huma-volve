
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/entity/login_entity.dart';
import 'package:dart_either/dart_either.dart';


abstract class LoginRepository {
  Future<Either<Failure, LoginEntity>> login(String email, String password);
}