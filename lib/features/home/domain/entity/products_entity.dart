import 'package:ecommerce_app_huma_volve/features/home/domain/entity/categories_entity.dart';

class ProductsEntity {
  ProductsEntity({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
    this.creationAt,
    this.updatedAt,
  });

  num? id;
  String? title;
  String? slug;
  num? price;
  String? description;
  CategoriesEntity? category;
  List<String>? images;
  String? creationAt;
  String? updatedAt;
}