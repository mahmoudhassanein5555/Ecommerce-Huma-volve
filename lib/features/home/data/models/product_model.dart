import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';

import 'category_model.dart';

class ProductModel extends ProductEntity {
  String? slug;
  String? creationAt;
  String? updatedAt;

  ProductModel({
    super.id,
    super.title,
    this.slug,
    super.price,
    super.description,
    super.category,
    super.images,
    this.creationAt,
    this.updatedAt,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null
        ? new CategoryModel.fromJson(json['category'])
        : null;
    images = json['images'].cast<String>();
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
}
