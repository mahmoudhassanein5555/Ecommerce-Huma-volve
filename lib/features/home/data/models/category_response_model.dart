
import 'package:json_annotation/json_annotation.dart';

part 'category_response_model.g.dart';

@JsonSerializable()
class CategoryResponseModel {
  final int id;
  final String name;
  final String slug;
  final String image;
  final DateTime creationAt;
  final DateTime updatedAt;

  const CategoryResponseModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoryResponseModelToJson(this);
}
