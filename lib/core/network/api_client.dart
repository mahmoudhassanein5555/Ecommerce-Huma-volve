import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}