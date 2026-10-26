import '../domain/entities/home_category_entity.dart';
import '../domain/entities/home_product_entity.dart';
import 'category_model.dart';

class HomeProductsModel extends HomeProductEntity {
  HomeProductsModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  HomeProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category =
        (json['category'] != null
                ? HomeCategoryModel.fromJson(json['category'])
                : null)
            as HomeCategoryEntity;
    images = json['images'].cast<String>();
  }
}
