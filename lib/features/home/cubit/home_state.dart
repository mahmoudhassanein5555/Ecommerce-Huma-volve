import '../domain/entities/product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ProductEntity> products;
  final bool isLoadingMore;
  final bool hasMore;

  HomeSuccess(
    this.products, {
    this.isLoadingMore = false,
    this.hasMore = true,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}