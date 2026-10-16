import 'package:ecommerce_app_huma_volve/features/home/domain/entity/categories_entity.dart';

class CategoriesModel extends CategoriesEntity{
  num? id;
  String? name;

  CategoriesModel({this.id, this.name});

  CategoriesModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
}