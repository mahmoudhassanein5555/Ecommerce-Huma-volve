import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/entities/product.dart';

class HomeData {
  const HomeData({required this.products, required this.categories});

  final List<Product> products;
  final List<String> categories;
}

class HomeRepositoryException implements Exception {
  const HomeRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class HomeRepository {
  HomeRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<HomeData> fetchHomeData() async {
    try {
      final responses = await Future.wait([
        _dio.get<dynamic>('/products'),
        _dio.get<dynamic>('/categories'),
      ]);

      return HomeData(
        products: _parseProducts(responses[0].data),
        categories: _parseCategories(responses[1].data),
      );
    } on DioException catch (error) {
      throw HomeRepositoryException(_messageFor(error));
    } on FormatException {
      throw const HomeRepositoryException(
        'The server returned invalid product or category data.',
      );
    }
  }

  List<Product> _parseProducts(dynamic data) {
    if (data is! List) {
      throw const FormatException('Expected a product list.');
    }

    return data.map((item) {
      if (item is Map<String, dynamic>) return Product.fromJson(item);
      if (item is Map) return Product.fromJson(Map<String, dynamic>.from(item));
      throw const FormatException('Expected a product object.');
    }).toList();
  }

  List<String> _parseCategories(dynamic data) {
    if (data is! List) {
      throw const FormatException('Expected a category list.');
    }

    return data.map((item) {
      if (item is! Map) {
        throw const FormatException('Expected a category object.');
      }
      final category = item['name'];
      if (category is! String || category.trim().isEmpty) {
        throw const FormatException('The category response is incomplete.');
      }
      return category.trim();
    }).toList();
  }

  String _messageFor(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'The request timed out. Please try again.';
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return 'Unable to connect. Check your internet connection and try again.';
    }
    if (error.response?.statusCode == 429) {
      return 'Too many requests. Please try again later.';
    }
    if ((error.response?.statusCode ?? 0) >= 500) {
      return 'The server is temporarily unavailable.';
    }
    return 'Unable to load products. Please try again.';
  }
}
