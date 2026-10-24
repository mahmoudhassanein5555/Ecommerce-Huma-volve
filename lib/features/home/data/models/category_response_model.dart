import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

/// id : 1
/// name : "Updated Category Name"

class CategoryResponseModel extends HomeCategoryEntity {
  CategoryResponseModel({super.id, super.name});

  CategoryResponseModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
}
