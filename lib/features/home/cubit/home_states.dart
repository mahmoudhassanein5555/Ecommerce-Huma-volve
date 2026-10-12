
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  final List<CategoryModel> categories;

  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeState {
  final String message;

  CategoriesError(this.message);
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  final List<ProductModel> products;

  ProductsSuccess(this.products);
}

class ProductsError extends HomeState {
  final String message;

  ProductsError(this.message);
}
