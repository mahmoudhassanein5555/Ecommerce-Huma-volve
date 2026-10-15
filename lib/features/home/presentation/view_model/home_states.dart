import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_product_entity.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class CategoriesLodaing extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<HomeCategoryEntity> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStates {
  final String errorMessage;
  CategoriesError(this.errorMessage);
}

class ProductsLoading extends HomeStates {}

class ProductsSuccess extends HomeStates {
  final List<HomeProductEntity> products;
  ProductsSuccess(this.products);
}

class ProductsError extends HomeStates {
  final String errorMessage;
  ProductsError(this.errorMessage);
}

class ProductsLoadingMore extends HomeStates {
  final List<HomeProductEntity> products;
  ProductsLoadingMore(this.products);
}

class ProductsLoadingError extends HomeStates {
  final List<HomeProductEntity> products;
  final String errorMessage;
  ProductsLoadingError({required this.products, required this.errorMessage});
}