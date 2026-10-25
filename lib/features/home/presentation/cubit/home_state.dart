import '../../domain/entities/product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ProductEntity> products;
  final bool hasMore;

  HomeSuccess({required this.products, required this.hasMore});
}

class HomeFailure extends HomeState {
  final String message;
  HomeFailure({required this.message});
}
