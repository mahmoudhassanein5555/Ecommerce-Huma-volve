import 'package:ecommerce_app_huma_volve/features/home/data/models/home_categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_products_entity.dart';

class HomeProductsModel extends HomeProductsEntity {
  HomeProductsModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.price,
    required super.description,
    required super.category,
    required super.images,
  });

  factory HomeProductsModel.fromJson(Map<String, dynamic> json) {
    return HomeProductsModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? '',
      slug: json["slug"] ?? '',
      price: json["price"] ?? 0,
      description: json["description"] ?? '',
      category: json["category"] != null
          ? HomeCategoriesModel.fromJson(json["category"])
          : HomeCategoriesModel(id: 0, name: ''),
      images: json["images"] != null ? List<String>.from(json["images"]) : [],
    );
  }
}
