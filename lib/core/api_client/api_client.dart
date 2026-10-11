import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';

abstract class ApiClient {
  static Dio get createDio => Dio(
    BaseOptions(baseUrl: ApiConsts.baseURL, receiveDataWhenStatusError: true),
  );
}
