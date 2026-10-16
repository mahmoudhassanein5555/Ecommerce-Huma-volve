// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponseModel _$CategoryResponseModelFromJson(
  Map<String, dynamic> json,
) => CategoryResponseModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  image: json['image'] as String,
  creationAt: DateTime.parse(json['creationAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CategoryResponseModelToJson(
  CategoryResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'image': instance.image,
  'creationAt': instance.creationAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
