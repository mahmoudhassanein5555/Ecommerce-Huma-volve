import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.createDio();

  final Dio _dio;

  Future<List<dynamic>> fetchProducts({
    int? categoryId,
    String? title,
    int offset = 0,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{'offset': offset, 'limit': limit};
    if (categoryId != null) {
      queryParameters['categoryId'] = categoryId;
    }
    if (title != null && title.trim().isNotEmpty) {
      queryParameters['title'] = title.trim();
    }

    final response = await _dio.get<List<dynamic>>(
      '/products',
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('The store returned no products.');
    }
    return data;
  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await _dio.get<List<dynamic>>(
      '/categories',
      queryParameters: const {'limit': 20},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('The store returned no categories.');
    }
    return data;
  }
}
