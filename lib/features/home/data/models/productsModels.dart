

import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_products_entity.dart';

import 'categoriesModels.dart';

class productsModels extends HomeProductsEntity{
  productsModels(
      {
        super.id,
        super.title,
        super.slug,
        super.price,
        super.description,
        required super.category,
        super.images,

      });

  productsModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = (json['category'] != null
        ? categoriesModels.fromJson(json['category'])
        : null) as HomeCategoryEntity;
    images = json['images'].cast<String>();

  }


}



