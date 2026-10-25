import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class CategoriesLoading extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<HomeCategoryEntity> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStates {
  final String error;
  CategoriesError(this.error);
}

class ProductsLoading extends HomeStates {}

class ProductsSuccess extends HomeStates {
  final List<HomeProductEntity> products;
  ProductsSuccess(this.products);
}

class ProductsError extends HomeStates {
  final String error;
  ProductsError(this.error);
}

class ProductsLoadMore extends HomeStates {}

class ProductsLoadMoreError extends HomeStates {
  final String errorMessage;
  ProductsLoadMoreError(this.errorMessage);
}
