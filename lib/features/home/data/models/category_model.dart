import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';

class CategoryModel {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? creationAt;
  String? updatedAt;

  CategoryModel(
      {this.id,
        this.name,
        this.slug,
        this.image,
        this.creationAt,
        this.updatedAt});

  CategoryModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
  CategoryEntity toDomain() {
    return CategoryEntity(id: id, name: name ?? "", slug: slug ?? "",
        image: image ?? "", creationAt: creationAt ?? "", updatedAt: updatedAt ?? "");
  }
}
