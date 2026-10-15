import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final List<Color> colors;
  final List<String> sizes;

  String get imageUrl => images.isEmpty ? '' : images.first;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    this.colors = const [],
    this.sizes = const [],
  });
}
