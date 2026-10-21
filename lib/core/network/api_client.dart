import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../storage/token_storage.dart';

/// One configured Dio for the whole app: base URL, timeouts, auth header
/// and debug logging live here, not in each feature service.
class ApiClient {
  ApiClient(this._tokenStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            headers: {'Accept': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenStorage.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true, compact: true),
      );
    }
  }

  final Dio dio;
  final TokenStorage _tokenStorage;
}
