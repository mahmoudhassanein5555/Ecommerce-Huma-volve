part of 'product_details_cubit.dart';

sealed class ProductDetailsState {
  const ProductDetailsState();
}

final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}

final class ProductDetailsSuccess extends ProductDetailsState {
  final ProductDetailsEntity product;

  const ProductDetailsSuccess(this.product);
}

final class ProductDetailsFailure extends ProductDetailsState {
  final String message;

  const ProductDetailsFailure(this.message);
}
