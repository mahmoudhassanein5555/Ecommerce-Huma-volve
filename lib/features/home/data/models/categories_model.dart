import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_catagory_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    super.id,
    super.name,
  });

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) => CategoryModel(
        id: json["id"] is num
            ? (json["id"] as num).toInt()
            : int.tryParse(json["id"]?.toString() ?? ''),
        name: json["name"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
