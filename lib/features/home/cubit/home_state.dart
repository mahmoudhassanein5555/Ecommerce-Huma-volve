import 'package:ecommerce_app_huma_volve/features/home/services/model/product_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class categoriesLoadedState extends HomeState {}

class categoriesErrorState extends HomeState {
  final String errorMessage;

  categoriesErrorState(this.errorMessage);
}

class categoriesSuccessState extends HomeState {
  final List categories;

  categoriesSuccessState(this.categories);
}

class productsLoadedState extends HomeState {}

class productsErrorState extends HomeState {
  final String errorMessage;

  productsErrorState(this.errorMessage);
}

class productsSuccessState extends HomeState {
  final List<ProductModel> products;

  productsSuccessState(this.products);
}
