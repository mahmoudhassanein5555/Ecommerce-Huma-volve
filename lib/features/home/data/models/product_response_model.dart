import 'package:json_annotation/json_annotation.dart';

part 'product_response_model.g.dart';

@JsonSerializable()
class ProductResponseModel {
  final int id;
  final String title;
  final String slug;
  final num price;
  final String description;
  final CategoryModel category;
  final List<String> images;
  final DateTime creationAt;
  final DateTime updatedAt;

  const ProductResponseModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String image;
  final DateTime creationAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
