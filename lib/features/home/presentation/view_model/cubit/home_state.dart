import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_products_entity.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class CategoriesLoading extends HomeState {}

final class CategoriesSuccess extends HomeState {
  final List<HomeCategoriesEntity> categories;
  CategoriesSuccess(this.categories);
}

final class CategoriesError extends HomeState {
  final String message;
  CategoriesError(this.message);
}

final class ProductsLoading extends HomeState {}

final class ProductsSuccess extends HomeState {
  final List<HomeProductsEntity> products;
  ProductsSuccess(this.products);
}

final class ProductsError extends HomeState {
  final String message;
  ProductsError(this.message);
}

final class ProductLoadingMore extends HomeState {}

final class ProductErrorMore extends HomeState {
  final String message;
  ProductErrorMore(this.message);
}
