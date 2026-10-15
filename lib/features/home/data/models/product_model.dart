import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final description = json['description'];
    final price = json['price'];
    final images = json['images'];

    if (id is! int ||
        title is! String ||
        description is! String ||
        price is! num ||
        images is! List ||
        images.any((image) => image is! String)) {
      throw const FormatException('Invalid product response');
    }

    return ProductModel(
      id: id.toString(),
      name: title,
      description: description,
      price: price.toDouble(),
      images: List<String>.from(images),
    );
  }
}
