import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/category_dto.dart';
import '../models/product_dto.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<ProductDto>> fetchProducts();
  Future<List<CategoryDto>> fetchCategories();
}

class DioHomeRemoteDataSource implements HomeRemoteDataSource {
  DioHomeRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  @override
  Future<List<ProductDto>> fetchProducts() async {
    final response = await _dio.get<dynamic>('/products');
    return _parseList(response.data, ProductDto.fromJson);
  }

  @override
  Future<List<CategoryDto>> fetchCategories() async {
    final response = await _dio.get<dynamic>('/categories');
    return _parseList(response.data, CategoryDto.fromJson);
  }

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) parse,
  ) {
    if (data is! List) throw const FormatException('Expected a JSON list.');
    return data.map((item) {
      if (item is Map<String, dynamic>) return parse(item);
      if (item is Map) return parse(Map<String, dynamic>.from(item));
      throw const FormatException('Expected an object in the response list.');
    }).toList();
  }
}
