import '../../domain/entities/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  const HomeCategoryModel({
    required super.id,
    required super.name,
  });

  factory HomeCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HomeCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
    );
  }

  factory HomeCategoryModel.fromEntity(
    HomeCategoryEntity entity,
  ) {
    return HomeCategoryModel(
      id: entity.id,
      name: entity.name,
    );
  }
}