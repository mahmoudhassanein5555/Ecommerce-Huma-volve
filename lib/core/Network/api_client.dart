import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiClient {
  Dio dio ;
  ApiClient() : dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
}