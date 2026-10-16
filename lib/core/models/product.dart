import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String category;
  final double price;
  final String imageUrl;
  final List<Color> colors;
  final List<String> sizes;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.colors = const [],
    this.sizes = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryData = json['category'];
    final category = categoryData is Map<String, dynamic>
        ? categoryData
        : const <String, dynamic>{};
    final images = json['images'];
    final imageUrl = images is List
        ? images.whereType<String>().firstWhere(
            (url) => url.trim().isNotEmpty,
            orElse: () => '',
          )
        : '';
    final id = json['id'];
    final price = json['price'];

    if (id == null || price is! num || json['title'] is! String) {
      throw const FormatException('Invalid product returned by the API');
    }

    return Product(
      id: id.toString(),
      name: json['title'] as String,
      description: json['description'] is String
          ? json['description'] as String
          : '',
      categoryId: category['id']?.toString() ?? '',
      category: category['name'] is String
          ? category['name'] as String
          : 'Uncategorized',
      price: price.toDouble(),
      imageUrl: imageUrl,
    );
  }
}

class ProductCategory {
  final String id;
  final String name;

  const ProductCategory({required this.id, required this.name});
}
