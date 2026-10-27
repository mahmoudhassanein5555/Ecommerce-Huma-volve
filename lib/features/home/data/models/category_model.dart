import '../../domain/entities/category_entity.dart';

class CategoryModel {
  const CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? (json['name'] as String).trim()
          : 'Uncategorized',
    );
  }

  final int id;
  final String name;

  CategoryEntity toEntity() => CategoryEntity(id: id, name: name);
}
