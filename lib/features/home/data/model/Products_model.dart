import 'package:ecommerce_app_huma_volve/features/home/domain/entity/products_entity.dart';

import 'Categories_model.dart';

class ProductsModel extends ProductsEntity {
  ProductsModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
    super.creationAt,
    super.updatedAt,
  });

  ProductsModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null
        ? CategoriesModel.fromJson(json['category'])
        : null;
    images = json['images'] != null ? json['images'].cast<String>() : [];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
}