import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';

class ApiClient {
  Dio dio;
  ApiClient() : dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
}


// https://api.escuelajs.co/api/v1/products?limit=20&offset=10
