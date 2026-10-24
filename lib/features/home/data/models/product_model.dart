import 'package:ecommerce_app_huma_volve/features/home/data/models/categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.title,
    super.price,
    super.description,
    super.images,
    super.category,
  });

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) => ProductModel(
        id: json["id"] is num ? (json["id"] as num).toInt() : int.tryParse(json["id"]?.toString() ?? ''),
        title: json["title"]?.toString(),
        price: json["price"] is num ? json["price"] as num : num.tryParse(json["price"]?.toString() ?? ''),
        description: json["description"]?.toString(),
        images: json["images"] is List
            ? (json["images"] as List).map((x) => x.toString()).toList()
            : null,
        category: json["category"] is Map
            ? CategoryModel.fromJson(json["category"] as Map)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "images": images,
        "category": category != null && category is CategoryModel
            ? (category as CategoryModel).toJson()
            : null,
      };
}
