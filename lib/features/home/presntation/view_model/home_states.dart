import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class CategoriesLoading extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<HomeCategoryEntity> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStates {
  final String message;
  CategoriesError(this.message);
}

class ProductLoading extends HomeStates {}

class ProductSuccess extends HomeStates {
  final List<HomeProductEntity> products;
  ProductSuccess(this.products);
}

class ProductError extends HomeStates {
  final String message;
  ProductError(this.message);
}