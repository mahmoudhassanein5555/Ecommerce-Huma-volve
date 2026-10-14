import '../../domain/entities/product.dart';

class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final description = json['description'];
    final price = json['price'];
    final rawImages = json['images'];
    final categoryJson = json['category'];

    if ((id is! int && id is! String) ||
        title is! String ||
        description is! String ||
        price is! num ||
        (categoryJson != null && categoryJson is! Map)) {
      throw const FormatException('The product response is incomplete.');
    }

    var imageUrl = '';
    if (rawImages is List) {
      imageUrl = rawImages
          .whereType<String>()
          .map((image) => image.trim())
          .firstWhere((image) => image.isNotEmpty, orElse: () => '');
    } else if (rawImages is String) {
      imageUrl = rawImages.trim();
    } else if (rawImages != null) {
      throw const FormatException('The product images are invalid.');
    }

    final rawCategoryName = categoryJson?['name'];
    if (rawCategoryName != null && rawCategoryName is! String) {
      throw const FormatException('The product category is invalid.');
    }

    return ProductDto(
      id: id.toString(),
      title: title,
      description: description,
      price: price.toDouble(),
      imageUrl: imageUrl,
      category: rawCategoryName as String? ?? '',
    );
  }

  Product toEntity() => Product(
    id: id,
    name: title,
    description: description,
    price: price,
    imageUrl: imageUrl,
    category: category,
    colorHexCodes: const ['#FFFFFFFF'],
    sizes: const ['One Size'],
  );
}
