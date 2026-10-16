import 'package:ecommerce_app_huma_volve/core/networking/api_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_response_model.dart';

class AuthRemoteDataSource {
  final ApiServices apiServices;

  AuthRemoteDataSource(this.apiServices);

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    return await apiServices.login(request);
  }

  Future<SignUpResponseModel> signUp(SignUpRequestModel request) async {
    return await apiServices.signUp(request);
  }
}
