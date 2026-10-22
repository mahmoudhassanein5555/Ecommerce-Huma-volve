
import '../categoryModel.dart';

class ProductModel {
  int? id;
  String? title;
  String? slug;
  num? price;
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: json['price'],
      description: json['description'],
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'])
          : null,
      images: json['images'] is List
          ? (json['images'] as List)
          .whereType<String>()
          .toList()
          : [],
      creationAt: json['creationAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
