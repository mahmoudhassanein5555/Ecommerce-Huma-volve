import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constants.dart';

import 'auth_interceptor.dart';

class DioHelper {
  static late Dio _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': ApiConstants.contentType},
      ),
    );

    // إضافة الـ Interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(url, queryParameters: queryParameters);
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(url, data: data, queryParameters: queryParameters);
  }

  static Future<Response> putData({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.put(url, data: data, queryParameters: queryParameters);
  }

  static Future<Response> deleteData({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.delete(url, data: data, queryParameters: queryParameters);
  }
}
