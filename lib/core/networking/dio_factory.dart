import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/local_database/shared_prefs_helper.dart';
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
    final token = await SharedPrefHelper.getString(
      SharedPrefHelper.userTokenKey,
    );
    dio?.options.headers = {
      'Accept': 'application/json',
      // accept:*/*
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
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
