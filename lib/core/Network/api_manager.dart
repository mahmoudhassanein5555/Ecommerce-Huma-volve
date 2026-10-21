import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';

class ApiManager {
  Dio dio;
  ApiManager() : dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)){
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args){
          if(options.path.contains('/posts')){
            return false;
          }
          return !args.isResponse || !args.hasUint8ListData;

    }
         )
       );
}
}