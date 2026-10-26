import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  HomeCategoryModel({super.id, super.name});

  HomeCategoryModel.fromJson(Map<String, dynamic> json)
      : super(id: json['id'], name: json['name']);
}
