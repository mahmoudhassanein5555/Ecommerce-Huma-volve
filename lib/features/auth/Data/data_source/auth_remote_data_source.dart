import 'package:ecommerce_app_huma_volve/features/auth/Data/model/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/model/sign_up_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignUpModel> SingUp(String email, String password, String name);
  Future<LoginModel> Login(String email, String password);
}
