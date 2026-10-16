part of 'all_products_cubit.dart';

@immutable
sealed class AllProductsState {}

final class AllProductsInitial extends AllProductsState {}

final class AllProductsLoading extends AllProductsState {}

final class AllProductsSuccess extends AllProductsState {
  final List<Product> products;
  final bool hasMoreData;

  AllProductsSuccess({
    required this.products,
    this.hasMoreData = true,
  });
}

final class AllProductsFail extends AllProductsState {
  final String errorMessage;

  AllProductsFail({required this.errorMessage});
}
