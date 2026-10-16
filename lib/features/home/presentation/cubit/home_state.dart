
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/products_entity.dart';

abstract class HomeState {}

final class HomeInitialState extends HomeState {}

final class CategoriesLoadingState extends HomeState {}

final class CategoriesSuccessState extends HomeState {
  final List<CategoriesEntity> categories;

  CategoriesSuccessState({required this.categories});
}

final class CategoriesErrorState extends HomeState {
  final String errorMessage;

  CategoriesErrorState({required this.errorMessage});
}

final class ProductsLoadingState extends HomeState {}

final class ProductsSuccessState extends HomeState {
  final List<ProductsEntity> products;

  ProductsSuccessState({required this.products});
}

final class ProductsErrorState extends HomeState {
  final String errorMessage;

  ProductsErrorState({required this.errorMessage});
}

final class ProductsLoadingMoreState extends HomeState {}

final class ProductsLoadingMoreErrorState extends HomeState {
  final String errorMessage;

  ProductsLoadingMoreErrorState({required this.errorMessage});
}