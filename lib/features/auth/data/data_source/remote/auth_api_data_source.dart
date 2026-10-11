import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/core/errors/remote_exption.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_responce.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/register_responce.dart';
import 'package:injectable/injectable.dart';
@Singleton(as: AuthRemoteDataSource)
class AuthApiDataSource implements AuthRemoteDataSource {
  final Dio _dio;
  AuthApiDataSource(this._dio);

  @override
  Future<LoginResponse> login(LoginRequest loginRequset) async {
    try {
      final response = await _dio.post(
        ApiConsts.loginEndPoint,
        data: loginRequset.toJson(),
      );
      final loginResponce = LoginResponse.fromJson(response.data);
      return loginResponce;
    } catch (e) {
      String? msg;
      if (e is DioException) {
        msg = e.response?.data["message"];
      }
      throw RemoteExptions(msg ?? "Failed to Login");
    }
  }

  @override
  Future<RegisterResponse> register(RegisterRequest registerRequset) async {
    try {
      final response = await _dio.post(
        ApiConsts.registerEndPoint,
        data: registerRequset.toJson(),
      );
      final registerResponce = RegisterResponse.fromJson(response.data);
      return registerResponce;
    } catch (e) {
      String? msg;
      if (e is DioException) {
        msg = e.response?.data["message"];
      }
      throw RemoteExptions(msg ?? "Failed to Register");
    }
  }
}
