import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClint {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.escuelajs.co/api/v1",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  )..interceptors.add(PrettyDioLogger(requestBody: true));
}
