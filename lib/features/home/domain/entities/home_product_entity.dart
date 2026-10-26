import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class HomeProductEntity {
  int id;
  String title;
  String slug;
  double price;
  String description;
  HomeCategoryEntity category;
  List<String> images;

  HomeProductEntity({
    this.id = 0,
    this.title = '',
    this.slug = '',
    this.price = 0.0,
    this.description = '',
    this.category = const HomeCategoryEntity(),
    this.images = const [],
  });
}