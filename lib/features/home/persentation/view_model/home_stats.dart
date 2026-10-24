import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

abstract class HomeStats {}

class HomeInitial extends HomeStats {}

class CategoriesLoading extends HomeStats {}

class CategoriesSuccess extends HomeStats {
  final List<HomeCategoryEntity> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStats {
  final String errorMessage;
  CategoriesError(this.errorMessage);
}

class ProductsLoading extends HomeStats {}

class ProductsSuccess extends HomeStats {
  final List<HomeProductEntity> products;
  ProductsSuccess(this.products);
}

class ProductsError extends HomeStats {
  final String errorMessage;
  ProductsError(this.errorMessage);
}
