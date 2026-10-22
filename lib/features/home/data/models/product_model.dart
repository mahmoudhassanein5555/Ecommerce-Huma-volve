import '../../domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages
              .whereType<String>()
              .where((url) => url.startsWith('http'))
              .toList()
        : const <String>[];
    final rawCategory = json['category'];

    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled product',
      description: (json['description'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: images,
      category: CategoryModel.fromJson(
        rawCategory is Map<String, dynamic> ? rawCategory : const {},
      ),
    );
  }

  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final CategoryModel category;

  ProductEntity toEntity() => ProductEntity(
    id: id,
    title: title,
    description: description,
    price: price,
    images: images,
    category: category.toEntity(),
  );
}
