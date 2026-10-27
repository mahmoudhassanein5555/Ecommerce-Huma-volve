import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'category_model.dart';

class HomeProductModel extends HomeProductEntity {
  HomeProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: json['price'],
      description: json['description'],
      category: json['category'] != null
          ? HomeCategoryModel.fromJson(json['category'])
          :  HomeCategoryModel(), 
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}