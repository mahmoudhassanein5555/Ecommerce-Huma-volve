import '../models/category_model.dart';
import '../models/products_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class CategoriesLoading extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<CategoryModel> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStates {
  final String error;
  CategoriesError(this.error);
}

class ProductsLoading extends HomeStates {}

class ProductsSuccess extends HomeStates {
  final List<ProductsModel> products;
  ProductsSuccess(this.products);
}

class ProductsError extends HomeStates {
  final String error;
  ProductsError(this.error);
}
