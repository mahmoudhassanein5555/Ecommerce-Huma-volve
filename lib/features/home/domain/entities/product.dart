import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.colorHexCodes,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final title = json['title'] ?? json['name'];
    final description = json['description'];
    final price = json['price'];
    final rawImages = json['images'];
    final categoryValue = json['category'];

    if ((rawId is! int && rawId is! String) ||
        title is! String ||
        description is! String ||
        price is! num) {
      throw const FormatException('The product response is incomplete.');
    }

    var imageUrl = '';
    if (rawImages is List) {
      imageUrl = rawImages
          .whereType<String>()
          .map((image) => image.trim())
          .firstWhere((image) => image.isNotEmpty, orElse: () => '');
    } else if (rawImages is String) {
      imageUrl = rawImages.trim();
    }

    String categoryName = '';
    if (categoryValue is Map) {
      final rawCategoryName = categoryValue['name'];
      if (rawCategoryName is String) {
        categoryName = rawCategoryName.trim();
      }
    } else if (categoryValue is String) {
      categoryName = categoryValue.trim();
    }

    final rawColors = json['colorHexCodes'] ?? json['colors'];
    final rawSizes = json['sizes'];

    return Product(
      id: rawId.toString(),
      name: title.trim(),
      description: description.trim(),
      price: price.toDouble(),
      imageUrl: imageUrl,
      category: categoryName,
      colorHexCodes: _parseStringList(rawColors, fallback: const ['#FFFFFFFF']),
      sizes: _parseStringList(rawSizes, fallback: const ['One Size']),
    );
  }

  static List<String> _parseStringList(dynamic value, {required List<String> fallback}) {
    if (value is! List) return fallback;
    final parsed = value.whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
    return parsed.isEmpty ? fallback : parsed;
  }

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> colorHexCodes;
  final List<String> sizes;

  List<Color> get colors =>
      colorHexCodes.map((hex) => _hexToColor(hex)).toList(growable: false);

  static Color _hexToColor(String hex) {
    final normalized = hex.trim();
    final cleaned = normalized.startsWith('#') ? normalized.substring(1) : normalized;
    final safeValue = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    final parsed = int.tryParse(safeValue, radix: 16);
    return Color(parsed ?? 0xFFFFFFFF);
  }
}
