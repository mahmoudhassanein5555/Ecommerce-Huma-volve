import 'category_entity.dart';

class ProductEntity {
  int? id;
  String? title;
  int? price;
  String? description;
  CategoryEntity? category;
  List<String>? images;

  ProductEntity({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.images,
  });
}
