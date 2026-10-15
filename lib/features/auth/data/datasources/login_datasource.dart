import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_model.dart';

abstract class LoginDatasource {
  Future<LoginModel> login({required String email, required String password});
}
