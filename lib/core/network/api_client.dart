import 'package:dio/dio.dart';

class ApiClient {
  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://api.escuelajs.co/api/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
