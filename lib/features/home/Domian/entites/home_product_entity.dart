import 'package:ecommerce_app_huma_volve/features/home/Data/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';

class HomeProductEntity {
  final int? id;
  final String? title;
  final String? slug;
  final int? price;
  final String? description;
  final HomeCategoryEntity? category;
  final List<String>? images;

  const HomeProductEntity({
    this.id = 0,
    this.title = "",
    this.slug = "",
    this.price = 0,
    this.description = "",
    this.category = const HomeCategoryEntity(),
    this.images = const [],
  });
}
