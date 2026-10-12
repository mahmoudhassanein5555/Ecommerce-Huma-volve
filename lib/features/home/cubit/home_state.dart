import 'package:ecommerce_app_huma_volve/features/home/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  HomeSuccess({
    required this.categories,
    required this.products,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({
    required this.message,
  });
}