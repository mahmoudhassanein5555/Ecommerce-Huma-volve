import '../../../../core/domain/entities/product.dart';
import '../../../../core/utils/image_url_sanitizer.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.colors,
    required super.sizes,
    super.categoryId,
    super.categoryName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['title'];
    final description = json['description'];
    final price = json['price'];
    final images = json['images'];

    if (id is! num ||
        name is! String ||
        description is! String ||
        price is! num ||
        images is! List) {
      throw const FormatException('Invalid product response from store.');
    }

    final imageUrl = ImageUrlSanitizer.firstValidUrl(
      images.whereType<String>(),
    );

    final category = json['category'];
    final categoryId = category is Map && category['id'] is num
        ? (category['id'] as num).toInt()
        : null;
    final categoryName = category is Map && category['name'] is String
        ? category['name'] as String
        : null;

    return ProductModel(
      id: id.toString(),
      name: name,
      description: description,
      price: price.toDouble(),
      imageUrl: imageUrl,
      colors: const [],
      sizes: const [],
      categoryId: categoryId,
      categoryName: categoryName,
    );
  }
}
