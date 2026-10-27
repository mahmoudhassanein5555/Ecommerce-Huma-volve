
import 'package:ecommerce_app_huma_volve/features/home/data/service/models/category_model%20.dart';

class ProductModel {
  int? id;
  String? title;
  String? slug;
  int? price;
  String? description;
  CategoryModel? category;
  List<String>? images;
  String? creationAt;
  String? updatedAt;

  ProductModel({
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

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    images = json['images'].cast<String>();
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
}