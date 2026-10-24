import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_catagory_entity.dart';

class ProductEntity {
  final int? id;
  final String? title;
  final num? price;
  final String? description;
  final List<String>? images;
  final CategoryEntity? category;

  const ProductEntity({
    this.id,
    this.title,
    this.price,
    this.description,
    this.images,
    this.category,
  });
}
