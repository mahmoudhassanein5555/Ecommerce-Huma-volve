import 'package:ecommerce_app_huma_volve/features/home/home_services/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/home_services/models/product_model.dart';

abstract class HomeStats {}

class HomeInitial extends HomeStats {}

class CategoriesLoading extends HomeStats {}

class CategoriesSuccess extends HomeStats {
  final List<CategoryModel> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeStats {
  final String errorMessage;
  CategoriesError(this.errorMessage);
}

class ProductsLoading extends HomeStats {}

class ProductsSuccess extends HomeStats {
  final List<ProductModel> products;
  ProductsSuccess(this.products);
}

class ProductsError extends HomeStats {
  final String errorMessage;
  ProductsError(this.errorMessage);
}
