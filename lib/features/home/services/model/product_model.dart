import 'package:ecommerce_app_huma_volve/features/home/services/model/category_model.dart';

class ProductModel {
  int? id;
  String? title;
  String? slug;
  int? price;
  String? description;
  CategoryModel? categoryModel;
  List<String>? images;

  ProductModel({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.categoryModel,
    this.images,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    slug = json["slug"];
    price = json["price"];
    description = json["description"];
    categoryModel = json["category"] == null
        ? null
        : CategoryModel.fromJson(json["category"]);
    images = json["images"] == null ? null : List<String>.from(json["images"]);
  }
}
