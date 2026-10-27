import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';

class ProductDetailsModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final List<String> images;

  const ProductDetailsModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final rawPrice = json['price'];
    final rawId = json['id'];

    return ProductDetailsModel(
      id: rawId is int ? rawId : int.tryParse('$rawId'),
      title: json['title'] is String ? json['title'] as String : null,
      price: rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse('$rawPrice'),
      description: json['description'] is String
          ? json['description'] as String
          : null,
      images: rawImages is List
          ? rawImages.whereType<String>().toList(growable: false)
          : const [],
    );
  }

  ProductDetailsEntity toDomain() {
    final productId = id;
    final productTitle = title;
    final productPrice = price;
    final productDescription = description;
    if (productId == null ||
        productTitle == null ||
        productPrice == null ||
        productDescription == null) {
      throw const FormatException('The product response is incomplete.');
    }

    return ProductDetailsEntity(
      id: productId,
      title: productTitle,
      price: productPrice,
      description: productDescription,
      images: images,
    );
  }
}
