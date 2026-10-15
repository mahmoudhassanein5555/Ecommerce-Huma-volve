import '../../domain/entities/home_category.dart';

class HomeCategoryModel extends HomeCategory {
  const HomeCategoryModel({required super.id, required super.name});

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! num || name is! String) {
      throw const FormatException('Invalid category response from store.');
    }

    return HomeCategoryModel(id: id.toInt(), name: name);
  }
}
