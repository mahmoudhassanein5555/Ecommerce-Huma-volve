import '../models/Categories_model.dart';
import '../models/Products_model.dart';

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
