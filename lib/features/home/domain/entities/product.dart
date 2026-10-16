import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';

class Product {
  final int id;
  final String title;
  final String slug;
  final num price;
  final String description;
  final Category category;
  final List<String> images;
  final DateTime creationAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });
}
