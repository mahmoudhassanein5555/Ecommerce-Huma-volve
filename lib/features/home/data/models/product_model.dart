import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'category_model.dart';

class ProductModel extends HomeProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.images,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final images = json['images'];
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      category: category is Map<String, dynamic>
          ? CategoryModel.fromJson(category)
          : null,
      images: images is List
          ? images
                .map((e) => _cleanImageUrl(e.toString()))
                .where((url) => url.isNotEmpty)
                .toList()
          : const [],
    );
  }

  /// Some products in the public API have image links saved like
  /// `["https://..."]`, so the brackets and quotes are removed.
  static String _cleanImageUrl(String url) =>
      url.replaceAll(RegExp(r'[\[\]"]'), '').trim();
}
