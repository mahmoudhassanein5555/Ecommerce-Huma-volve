import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}
