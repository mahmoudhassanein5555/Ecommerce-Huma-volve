
import '../domain/entities/category_entity.dart';
import '../domain/entities/product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  final List<CategoryEntity> categories;

  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeState {
  final String message;

  CategoriesError(this.message);
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  final List<ProductEntity> products;
  final bool isLoadingMore;
  final bool hasMore;

  ProductsSuccess(
    this.products, {
    this.isLoadingMore = false,
    this.hasMore = true,
  });
}

class ProductsError extends HomeState {
  final String message;

  ProductsError(this.message);
}
