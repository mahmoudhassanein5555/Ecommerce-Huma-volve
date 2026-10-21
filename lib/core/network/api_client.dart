import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';

class ApiClient {
  static Dio? _dio;

  /// get instance of dio
  /// use that instance of entire of application
  static Dio get instance {
    _dio ??= _getDio();
    return _dio!;
  }

  /// Handle configuration of Dio(Request)
  static Dio _getDio() {
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    dio.interceptors.addAll([
      PrettyDioLogger(request: true, responseBody: true),
    ]);
    return dio;
  }
}