import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_categories_entity.dart';

class HomeCategoriesModel extends HomeCategoriesEntity {
  HomeCategoriesModel({required super.id, required super.name});

  factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoriesModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
