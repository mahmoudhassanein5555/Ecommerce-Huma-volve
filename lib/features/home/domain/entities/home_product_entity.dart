import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class HomeProductEntity {
  HomeProductEntity({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  num? id;
  String? title;
  String? slug;
  num? price;
  String? description;
  HomeCategoryEntity? category;
  List<String>? images;
}
