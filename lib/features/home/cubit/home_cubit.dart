import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/home_category_entity.dart';
import '../domain/entities/home_product_entity.dart';
import '../domain/usecases/get_home_categories_usecase.dart';
import '../domain/usecases/get_home_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeCategoriesUseCase getCategoriesUseCase;
  final GetHomeProductsUseCase getProductsUseCase;

  static const int pageSize = 10;

  List<HomeCategoryEntity> _categories = [];
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _isChangingCategory = false;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    try {
      _categories = await getCategoriesUseCase();

      if (_categories.isEmpty) {
        emit(HomeError(message: 'No categories found.'));
        return;
      }

      await fetchProductsByCategory(_categories.first.id);
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    if (_isChangingCategory) return;

    _isChangingCategory = true;
    _isLoadingMore = false;
    _offset = 0;
    _hasMore = true;

    emit(HomeLoading());

    try {
      final products = await getProductsUseCase(
        categoryId: categoryId,
        limit: pageSize,
        offset: 0,
      );

      _offset = products.length;
      _hasMore = products.length == pageSize;

      emit(
        HomeSuccess(
          categories: _categories,
          products: products,
          selectedCategoryId: categoryId,
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    } finally {
      _isChangingCategory = false;
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;

    if (currentState is! HomeSuccess ||
        _isLoadingMore ||
        _isChangingCategory ||
        !_hasMore) {
      return;
    }

    _isLoadingMore = true;

    emit(
      currentState.copyWith(isLoadingMore: true, clearLoadingMoreError: true),
    );

    try {
      final newProducts = await getProductsUseCase(
        categoryId: currentState.selectedCategoryId,
        limit: pageSize,
        offset: _offset,
      );

      final latestState = state;

      if (latestState is! HomeSuccess ||
          latestState.selectedCategoryId != currentState.selectedCategoryId) {
        return;
      }

      final combinedProducts = <HomeProductEntity>[
        ...latestState.products,
        ...newProducts,
      ];

      _offset += newProducts.length;
      _hasMore = newProducts.length == pageSize;

      emit(
        latestState.copyWith(
          products: combinedProducts,
          isLoadingMore: false,
          hasMore: _hasMore,
          clearLoadingMoreError: true,
        ),
      );
    } catch (e) {
      final latestState = state;

      if (latestState is HomeSuccess &&
          latestState.selectedCategoryId == currentState.selectedCategoryId) {
        emit(
          latestState.copyWith(
            isLoadingMore: false,
            loadingMoreError: e.toString(),
          ),
        );
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> retryLoadMore() async {
    await loadMoreProducts();
  }
}
