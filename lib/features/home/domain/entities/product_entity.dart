import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';

class ProductEntity {
  final int? id;
  final String title;
  final String slug;
  final int? price;
  final String description;
  final CategoryEntity? category;
  final List<String> images;
  final String creationAt;
  final String updatedAt;

  ProductEntity({
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
