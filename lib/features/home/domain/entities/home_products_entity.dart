import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_categories_entity.dart';

class HomeProductsEntity {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final HomeCategoriesEntity category;
  final List<String> images;

  const HomeProductsEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });
}
