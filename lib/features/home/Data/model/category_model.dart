import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';

class HomeCategoryModel {
  int? id;
  String? name;

  HomeCategoryModel({this.id, this.name});

  HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
