import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<Color> colors;
  final List<String> sizes;
  final int? categoryId;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.colors,
    required this.sizes,
    this.categoryId,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['title'];
    final description = json['description'];
    final price = json['price'];
    final images = json['images'];

    if (id is! num ||
        name is! String ||
        description is! String ||
        price is! num ||
        images is! List) {
      throw const FormatException('Invalid product response from store.');
    }

    final imageUrl = images
        .whereType<String>()
        .map((image) => image.trim())
        .firstWhere((image) => image.isNotEmpty, orElse: () => '');
    if (imageUrl.isEmpty) {
      throw const FormatException(
        'Product response does not include an image.',
      );
    }

    final category = json['category'];
    final categoryId = category is Map && category['id'] is num
        ? (category['id'] as num).toInt()
        : null;
    final categoryName = category is Map && category['name'] is String
        ? category['name'] as String
        : null;

    return Product(
      id: id.toString(),
      name: name,
      description: description,
      price: price.toDouble(),
      imageUrl: imageUrl,
      colors: const [],
      sizes: const [],
      categoryId: categoryId,
      categoryName: categoryName,
    );
  }
}
