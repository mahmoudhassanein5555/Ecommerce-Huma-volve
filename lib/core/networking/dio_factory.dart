import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 50);

    if (dio == null) {
      dio = Dio();

      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      addDioInterceptor();
      await addDioHeaders(); // ✅ مهم جدًا

      return dio!;
    } else {
      return dio!;
    }
  }

  static Future<void> addDioHeaders() async {
    dio?.options.headers = {
      'Accept': 'application/json',
      // accept:*/*
      'Content-Type': 'application/json',
      
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        enabled: kDebugMode,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
