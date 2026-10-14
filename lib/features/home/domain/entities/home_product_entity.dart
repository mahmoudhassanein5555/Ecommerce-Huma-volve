import 'home_category_entity.dart';

class HomeProductEntity {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final HomeCategoryEntity category;
  final List<String> images;

  const HomeProductEntity({
    this.id = 0,
    this.title = '',
    this.slug = '',
    this.price = 0,
    this.description = '',
    this.category = const HomeCategoryEntity(),
    this.images = const [],
  });
}