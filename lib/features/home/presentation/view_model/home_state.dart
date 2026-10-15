import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class CategoriesLoadedState extends HomeState {}

class CategoriesErrorState extends HomeState {
  final String errorMessage;

  CategoriesErrorState(this.errorMessage);
}

class CategoriesSuccessState extends HomeState {
  final List<HomeCategoryEntity> categories;

  CategoriesSuccessState(this.categories);
}

class ProductsLoadedState extends HomeState {}

class ProductsErrorState extends HomeState {
  final String errorMessage;

  ProductsErrorState(this.errorMessage);
}

class ProductsSuccessState extends HomeState {
  final List<HomeProductEntity> products;

  ProductsSuccessState(this.products);
}

class MoreProductsLoadedState extends HomeState {}

class MoreProductsErrorState extends HomeState {
  final String errorMessage;

  MoreProductsErrorState(this.errorMessage);
}
