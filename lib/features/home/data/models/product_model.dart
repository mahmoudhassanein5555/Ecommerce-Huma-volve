import '../../domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.price,
    required super.description,
    required super.category,
    required super.images,
    required super.creationAt,
    required super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: json['price'],
      description: json['description'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : throw Exception('Product category is missing'),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((image) => image.toString())
          .toList(),
      creationAt: json['creationAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
