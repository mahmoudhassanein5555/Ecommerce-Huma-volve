
import '../domain/entities/home_category_entity.dart';
import '../domain/entities/home_product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<HomeCategoryEntity> categories;
  final List<HomeProductEntity> products;
  final int selectedCategoryId;
  final bool isLoadingMore;
  final bool hasMore;
  final String? loadingMoreError;

  HomeSuccess({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.loadingMoreError,
  });

  HomeSuccess copyWith({
    List<HomeCategoryEntity>? categories,
    List<HomeProductEntity>? products,
    int? selectedCategoryId,
    bool? isLoadingMore,
    bool? hasMore,
    String? loadingMoreError,
    bool clearLoadingMoreError = false,
  }) {
    return HomeSuccess(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId:
          selectedCategoryId ?? this.selectedCategoryId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadingMoreError: clearLoadingMoreError
          ? null
          : loadingMoreError ?? this.loadingMoreError,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
