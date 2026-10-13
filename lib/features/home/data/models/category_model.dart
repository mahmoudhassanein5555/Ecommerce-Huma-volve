import '../../domain/entity/home_category_entity.dart';

class CategoryModel extends HomeCategoryEntity {
  const CategoryModel({
    super.id,
    super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}