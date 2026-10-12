import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_constants.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest loginRequestBody);

  @POST(ApiConstants.signUp)
  Future<SignUpResponse> signUp(@Body() SignUpRequest loginRequestBody);
}
