part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategorySuccess extends HomeState {
  final List<CategoryEntity> categories;
  CategorySuccess({required this.categories});
}

class CategoryError extends HomeState {
  final String message;
  CategoryError({required this.message});
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  final List<ProductEntity> products;
  ProductsSuccess({required this.products});
}

class ProductsError extends HomeState {
  final String message;
  ProductsError({required this.message});
}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  HomeLoaded({required this.categories, required this.products});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
