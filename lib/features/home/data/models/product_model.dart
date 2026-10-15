import '../../domain/entity/home_product_entity.dart';
import 'category_model.dart';

class ProductModel extends HomeProductEntity {
  ProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : const CategoryModel(),
      images: (json['images'] as List?)?.cast<String>() ?? const [],
    );
  }
}