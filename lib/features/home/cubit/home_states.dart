import 'package:ecommerce_app_huma_volve/features/home/services/home_service.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/product_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class CategoriesLoading extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<CategoryModel> categories;

  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStates {
  final String errorMessage;

  CategoriesError(this.errorMessage);
}

class ProductsLoading extends HomeStates {}

class ProductsSuccess extends HomeStates {
  final List<ProductModel> products;

  ProductsSuccess(this.products);
}

class ProductsError extends HomeStates {
  final String errorMessage;

  ProductsError(this.errorMessage);
}
