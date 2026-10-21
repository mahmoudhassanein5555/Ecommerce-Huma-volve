import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';

class ApiClient {
  final Dio dio;
  ApiClient():dio=Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
}