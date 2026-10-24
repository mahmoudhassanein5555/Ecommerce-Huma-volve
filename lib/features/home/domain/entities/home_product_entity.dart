import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class HomeProductEntity {
  const HomeProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final HomeCategoryEntity? category;

  /// The first image, or an empty string if the product has none.
  String get imageUrl => images.isNotEmpty ? images.first : '';
}
