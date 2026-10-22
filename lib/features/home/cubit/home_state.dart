part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class CategorySuccess extends HomeState {
  final List<CategoryModel> categoryList;
  CategorySuccess(this.categoryList);
}

final class HomeFailureState extends HomeState {
  final String errorMessage;
  HomeFailureState(this.errorMessage);
}

final class HomeProductsSuccessState extends HomeState {
  final List<ProductModel> productList;

  HomeProductsSuccessState(this.productList);
}

final class HomeProductsLoadingState extends HomeState {}

final class HomeProductsFailureState extends HomeState {
  final String errorMessage;

  HomeProductsFailureState(this.errorMessage);
}
