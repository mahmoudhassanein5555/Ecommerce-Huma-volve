import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';

class ApiClient {
  static Dio createDio() {
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    dio.interceptors.addAll([
      PrettyDioLogger(request: true, responseBody: true),
    ]);
    return dio;
  }
}
