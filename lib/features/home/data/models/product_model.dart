import '../../domain/entities/home_category_entity.dart';
import '../../domain/entities/home_product_entity.dart';
import 'category_model.dart';

class HomeProductModel extends HomeProductEntity {
  const HomeProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      category: json['category'] != null
          ? HomeCategoryModel.fromJson(json['category'])
          : const HomeCategoryEntity(),
      images: List<String>.from(json['images'] ?? const []),
    );
  }
}