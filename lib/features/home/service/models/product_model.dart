
import 'package:ecommerce_app_huma_volve/features/home/service/models/category_model.dart';

class ProductModel {
  ProductModel({
      this.id, 
      this.title, 
      this.slug, 
      this.price, 
      this.description, 
      this.category,
      this.images,
      this.creationAt, 
      this.updatedAt,});

  ProductModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null;
    if (json['images'] != null && json['images'] is List) {
      images = [];
      for (var item in json['images']) {
        if (item is String) {
          String cleaned = item.replaceAll(RegExp(r'[\[\]\\"]'), '').trim();
          if (cleaned.isNotEmpty) {
            images!.add(cleaned);
          }
        }
      }
    } else {
      images = [];
    }
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
  num? id;
  String? title;
  String? slug;
  num? price;
  String? description;
  CategoryModel? category;
  List<String>? images;
  String? creationAt;
  String? updatedAt;



}

