import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/dummy_data.dart';

class HomeCategory {
  const HomeCategory({required this.slug, required this.name});

  final String slug;
  final String name;
}

class HomeRepository {
  HomeRepository({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  final Dio _dio;

  Future<({List<Product> products, List<HomeCategory> categories})>
  loadHome() async {
    final productResponse = await _dio.get<Map<String, dynamic>>(
      '/products',
      queryParameters: {'limit': 100},
    );
    final categoryResponse = await _dio.get<List<dynamic>>(
      '/products/category-list',
    );

    final productData = productResponse.data?['products'];
    final categoryData = categoryResponse.data;
    if (productData is! List || categoryData == null) {
      throw const FormatException('The product service returned invalid data.');
    }

    return (
      products: productData
          .whereType<Map<String, dynamic>>()
          .map(_productFromJson)
          .toList(growable: false),
      categories: categoryData
          .whereType<String>()
          .map((slug) => HomeCategory(slug: slug, name: _categoryName(slug)))
          .toList(growable: false),
    );
  }

  Product _productFromJson(Map<String, dynamic> json) {
    final images = json['images'];
    final imageUrl =
        json['thumbnail'] as String? ??
        (images is List && images.isNotEmpty
            ? images.first as String?
            : null) ??
        '';
    final categorySlug = json['category'] is Map<String, dynamic>
        ? (json['category'] as Map<String, dynamic>)['slug'] as String? ?? ''
        : json['category'] as String? ?? '';
    final category = categorySlug.toLowerCase();
    final sizes =
        category.contains('clothing') ||
            category.contains('shirt') ||
            category.contains('dress')
        ? ['S', 'M', 'L', 'XL']
        : ['One Size'];

    return Product(
      id: '${json['id'] ?? ''}',
      name: json['title'] as String? ?? 'Product',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: imageUrl,
      colors: const [Colors.black, Colors.white, Colors.grey],
      sizes: sizes,
      categorySlug: categorySlug,
    );
  }

  String _categoryName(String slug) {
    return slug
        .split('-')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }
}
