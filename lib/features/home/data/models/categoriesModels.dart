import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';

class categoriesModels extends HomeCategoryEntity {
  categoriesModels({
    super.id,
    super.name,
  });

  categoriesModels.fromJson(Map<String, dynamic> json)
      : super(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
  );
}