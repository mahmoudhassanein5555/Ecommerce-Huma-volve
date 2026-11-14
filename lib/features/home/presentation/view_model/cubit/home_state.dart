part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategorySuccess extends HomeState {
  final List<CategoryEntity> categories;
  final int selectedIndex;
  CategorySuccess({required this.categories, required this.selectedIndex});
}

class CategoryFailure extends HomeState {
  final Failure failure;
  CategoryFailure(this.failure);
}

class ProductLoading extends HomeState {}

class ProductSuccess extends HomeState {
  final List<ProductEntity> products;
  // final bool hasMore; only use it if you want to tell the user no more products
  final bool isLoadingMore;
  ProductSuccess({required this.products, this.isLoadingMore = false});
}

class ProductFailure extends HomeState {
  final Failure failure;
  ProductFailure(this.failure);
}

class LoadMoreProductsError extends ProductSuccess {
  final String errorMessage;
  LoadMoreProductsError({required super.products, required this.errorMessage});
}
