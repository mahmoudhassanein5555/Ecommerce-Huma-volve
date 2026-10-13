import '../domain/entities/home_category_entity.dart';
import '../domain/entities/home_product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<HomeCategoryEntity> categories;
  final List<HomeProductEntity> products;

  HomeSuccess({
    required this.categories,
    required this.products,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}