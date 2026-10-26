import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

class HomeProductModel extends HomeProductEntity {
  HomeProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  HomeProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? '';
    slug = json['slug'] ?? '';
    price = (json['price'] as num?)?.toDouble() ?? 0.0;
    description = json['description'] ?? '';
    if (json['category'] != null) {
      category = HomeCategoryModel.fromJson(json['category']);
    }
    final rawImages = json['images'];
    images = rawImages is List ? rawImages.map((e) => e.toString()).toList() : const [];
  }
}