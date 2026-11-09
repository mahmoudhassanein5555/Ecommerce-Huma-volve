import 'category_entity.dart';

class ProductEntity {
  int id;
  String title;
  String slug;
  int price;
  String description;
  CategoryEntity category;
  List<String> images;
  String creationAt;
  String updatedAt;

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
