import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkServices {


 Dio dio;

  NetworkServices()
    : dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl))
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
            enabled: kDebugMode,
            filter: (options, args) {
              if (options.path.contains('/posts')) {
                return false;
              }
              return !args.isResponse || !args.hasUint8ListData;
            },
          ),
        );

}