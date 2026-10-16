

import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_products_entity.dart';

import '../../data/models/categoriesModels.dart';
import '../../data/models/productsModels.dart';

abstract  class HomeStates {

}
class HomeInitial extends HomeStates{

}
class CategoriesIsLoading extends HomeStates{}

class CategoriesSuccess extends HomeStates{
  final List<HomeCategoryEntity> CategoriesModels;
  CategoriesSuccess(this.CategoriesModels);
}

class CategoriesError extends HomeStates{
  final String errorMessage;
  CategoriesError(this.errorMessage);
}


class ProductsIsLoading extends HomeStates{}

class ProductsSuccess extends HomeStates{
  final List<HomeProductsEntity> ProductsModels;
  ProductsSuccess(this.ProductsModels);
}

class ProductsError extends HomeStates{
  final String errorMessage;
  ProductsError(this.errorMessage);
}

class ProductsisLoadingMore extends HomeStates{}

class ProductsisLoadingError extends HomeStates{
  final String errorMessage;
  ProductsisLoadingError({required this.errorMessage});

}