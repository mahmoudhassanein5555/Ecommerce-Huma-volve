import 'package:flutter/material.dart';
import '../../../home/domain/entities/product.dart';

class WishlistProductModel extends Product {
  const WishlistProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.images,
    super.colors = const [],
    super.sizes = const [],
  });

  factory WishlistProductModel.fromEntity(Product product) {
    return WishlistProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      images: product.images,
      colors: product.colors,
      sizes: product.sizes,
    );
  }

  factory WishlistProductModel.fromMap(Map<dynamic, dynamic> map) {
    return WishlistProductModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      colors: (map['colors'] as List<dynamic>?)
              ?.map((e) => Color((e as num).toInt()))
              .toList() ??
          [],
      sizes: (map['sizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'colors': colors.map((c) => c.toARGB32()).toList(),
      'sizes': sizes,
    };
  }
}
