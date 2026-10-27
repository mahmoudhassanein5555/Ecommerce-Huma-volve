import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';

extension MapperToDomain on CategoryModel {
  CategoryEntity toDomain() {
    return CategoryEntity(
      id: id,
      name: name ?? "",
      slug: slug ?? "",
      image: image ?? "",
      creationAt: creationAt ?? "",
      updatedAt: updatedAt ?? "",
    );
  }
}

extension ProductMapperToDomain on ProductModel {
  ProductEntity toDomain() {
    return ProductEntity(
      id: id,
      title: title ?? "",
      slug: slug ?? "",
      price: price,
      description: description ?? "",
      category: category != null
          ? CategoryEntity(
              id: category?.id,
              name: category?.name ?? "",
              slug: category?.slug ?? "",
              image: category?.image ?? "",
              creationAt: category?.creationAt ?? "",
              updatedAt: category?.updatedAt ?? "",
            )
          : null,
      images: images ?? const [],
      creationAt: creationAt ?? "",
      updatedAt: updatedAt ?? "",
    );
  }
}
