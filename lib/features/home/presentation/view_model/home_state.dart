part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategorySuccess extends HomeState {
  final List<HomeCategoryEntity> categories;

  CategorySuccess(this.categories);
}

class CategoryFailure extends HomeState {
  final String errorMessage;

  CategoryFailure(this.errorMessage);
}

class ProductLoading extends HomeState {}

class ProductSuccess extends HomeState {
  final List<HomeProductEntity> products;

  ProductSuccess(this.products);
}

class ProductFailure extends HomeState {
  final String errorMessage;

  ProductFailure(this.errorMessage);
}
