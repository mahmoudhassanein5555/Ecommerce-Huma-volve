import '../../domain/entities/home_product_entity.dart';

class HomeProductModel extends HomeProductEntity {
  const HomeProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.images,
  });

  factory HomeProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawImages = json['images'];

    return HomeProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description']?.toString() ?? '',
      images: rawImages is List
          ? rawImages.map((image) => image.toString()).toList()
          : <String>[],
    );
  }

  factory HomeProductModel.fromEntity(
    HomeProductEntity entity,
  ) {
    return HomeProductModel(
      id: entity.id,
      title: entity.title,
      price: entity.price,
      description: entity.description,
      images: entity.images,
    );
  }
}