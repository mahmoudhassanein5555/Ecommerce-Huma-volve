import 'package:dio/dio.dart';

import 'api_interceptors.dart';
import 'dio_consumer.dart';
import 'end_points.dart';

final Dio appDio = Dio(
  BaseOptions(
    baseUrl: AppEndPoints.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
  ),
)..interceptors.add(ApiInterceptor());

final DioConsumer apiConsumer = DioConsumer(dio: appDio);
