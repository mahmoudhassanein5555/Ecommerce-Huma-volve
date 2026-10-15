import 'package:ecommerce_app_huma_volve/features/home/Data/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';

class HomeProductModel {
  int? id;
  String? title;
  String? slug;
  int? price;
  String? description;
  HomeCategoryModel? category;
  List<String>? images;

  HomeProductModel({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  HomeProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    slug = json["slug"];
    price = json["price"];
    description = json["description"];
    category = (json["category"] == null
        ? null
        : HomeCategoryModel.fromJson(json["category"]));

    images = json["images"]?.cast<String>().toList();
  }
}
