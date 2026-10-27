import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  HomeCategoryModel({
     super.id,
     super.name,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
}