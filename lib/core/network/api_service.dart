import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  late Dio dio;

  ApiService(){
    dio =Dio(
      BaseOptions(
        baseUrl: 'https://api.escuelajs.co/api/v1/',
        receiveDataWhenStatusError: true,
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: false,
  responseBody: false,
        responseHeader: false,
        error: true,
        compact: true
      ),
    );

  }
  Future<List<dynamic>> getProducts({
  required int offset,
  required int limit,
}) async {
  final response = await dio.get(
    'products',
    queryParameters: {
      'offset': offset,
      'limit': limit,
    },
  );

  return response.data as List<dynamic>;
}
}