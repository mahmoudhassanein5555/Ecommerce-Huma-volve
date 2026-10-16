import 'package:ecommerce_app_huma_volve/features/home/model/Categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/model/Products_model.dart';



abstract class HomeState {}

final class HomeInitialState extends HomeState {}

final class CategoriesLoadingState extends HomeState {}

final class CategoriesSuccessState extends HomeState {
  final List<CategoriesModel> categories;

  CategoriesSuccessState({required this.categories});
}

final class CategoriesErrorState extends HomeState {
  final String errorMessage;

  CategoriesErrorState({required this.errorMessage});
}

final class ProductsLoadingState extends HomeState {}

final class ProductsSuccessState extends HomeState {
  final List<ProductsModel> products;

  ProductsSuccessState({required this.products});
}

final class ProductsErrorState extends HomeState {
  final String errorMessage;

  ProductsErrorState({required this.errorMessage});
}