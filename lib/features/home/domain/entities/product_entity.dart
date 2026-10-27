import 'category_entity.dart';

class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final CategoryEntity category;
}
