import 'package:dio/dio.dart';

import '../models/product.dart';

class ProductApiService {
  static const _pageSize = 50;

  final Dio _dio;

  ProductApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.escuelajs.co/api/v1',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  Future<List<Product>> fetchProducts() async {
    final products = <Product>[];
    var offset = 0;

    while (true) {
      final response = await _dio.get<List<dynamic>>(
        '/products',
        queryParameters: {'limit': _pageSize, 'offset': offset},
      );
      final data = response.data;

      if (data == null) {
        throw const FormatException('The products API returned no data');
      }

      products.addAll(
        data.map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'The products API returned an invalid product',
            );
          }
          return Product.fromJson(item);
        }),
      );

      if (data.length < _pageSize) {
        return products;
      }
      offset += _pageSize;
    }
  }

  Future<Product> fetchProductById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/products/$id');
    final data = response.data;

    if (data == null) {
      throw const FormatException('The product API returned no data');
    }

    return Product.fromJson(data);
  }
}
