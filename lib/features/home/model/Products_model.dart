
import 'Categories_model.dart';

class ProductsModel {
  ProductsModel({
      this.id, 
      this.title, 
      this.slug, 
      this.price, 
      this.description, 
      this.category, 
      this.images, 
      this.creationAt, 
      this.updatedAt,});

  ProductsModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null ? CategoriesModel.fromJson(json['category']) : null;
    images = json['images'] != null ? json['images'].cast<String>() : [];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
  num? id;
  String? title;
  String? slug;
  num? price;
  String? description;
  CategoriesModel? category;
  List<String>? images;
  String? creationAt;
  String? updatedAt;


}