import 'package:dio/dio.dart';

import '../../../core/models/product.dart';
import '../models/home_category.dart';

class HomeRepository {
  HomeRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.escuelajs.co/api/v1',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  final Dio _dio;

  Future<List<Product>> fetchProducts({int? categoryId, String? title}) async {
    final queryParameters = <String, dynamic>{'offset': 0, 'limit': 20};
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

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid product response from store.');
      }
      return Product.fromJson(item);
    }).toList();
  }

  Future<List<HomeCategory>> fetchCategories() async {
    final response = await _dio.get<List<dynamic>>(
      '/categories',
      queryParameters: const {'limit': 20},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('The store returned no categories.');
    }

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid category response from store.');
      }
      return HomeCategory.fromJson(item);
    }).toList();
  }
}
