import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final image = json['image'];

    if (id is! int || name is! String || image is! String) {
      throw const FormatException('Invalid category response');
    }

    return CategoryModel(id: id, name: name, image: image);
  }
}
