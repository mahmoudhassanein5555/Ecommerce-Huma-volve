import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

abstract class ProductState {}

class ProductsInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsError extends ProductState {
  final String message;

  ProductsError(this.message);
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  ProductsLoaded({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });
}
