import 'package:equatable/equatable.dart';

import '../../../../core/dummy_data.dart' show Product;

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.products,
    required this.categories,
    required this.selectedCategory,
  });

  final List<Product> products;
  final List<String> categories;
  final String selectedCategory;

  @override
  List<Object?> get props => [products, categories, selectedCategory];
}

/// The request succeeded but returned no products for [selectedCategory].
class HomeEmpty extends HomeState {
  const HomeEmpty({required this.categories, required this.selectedCategory});

  final List<String> categories;
  final String selectedCategory;

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class HomeError extends HomeState {
  const HomeError({
    required this.message,
    required this.categories,
    required this.selectedCategory,
  });

  final String message;
  final List<String> categories;
  final String selectedCategory;

  @override
  List<Object?> get props => [message, categories, selectedCategory];
}
