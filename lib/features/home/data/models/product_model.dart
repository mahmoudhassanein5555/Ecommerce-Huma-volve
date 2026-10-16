import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.colors,
    required super.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];

    return ProductModel(
      id: json['id'].toString(),
      name: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: images.isNotEmpty ? images.first.toString() : '',
      colors: ['black'],
      sizes: ['One Size'],
    );
  }
}