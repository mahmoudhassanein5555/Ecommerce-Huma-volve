import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/home_category_use_case.dart';
import '../../domain/usecases/home_products_use_case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeCategoryUseCase homeCategoryUseCase;
  final HomeProductsUseCase homeProductsUseCase;

  HomeCubit({
    required this.homeCategoryUseCase,
    required this.homeProductsUseCase,
  }) : super(HomeInitial());

  static const int pageSize = 10;

  final List<ProductEntity> _products = [];
  List<CategoryEntity> _categories = [];
  int? categoryId;
  int _offset = 0;
  int _requestVersion = 0;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  Future<void> loadHome() async {
    final requestVersion = ++_requestVersion;
    _offset = 0;
    _hasMore = false;
    _isLoadingMore = false;
    _products.clear();
    emit(HomeLoadingState());

    final categoryResult = await homeCategoryUseCase();
    if (requestVersion != _requestVersion || isClosed) return;
    await categoryResult.when(
      success: (categoryList) async {
        _categories = categoryList;
        if (_categories.isEmpty) {
          _products.clear();
          categoryId = null;
          _hasMore = false;
          emit(CategorySuccess(_categories));
          emit(HomeProductsSuccessState(const []));
          return;
        }

        categoryId = _categories.first.id;
        emit(CategorySuccess(_categories));
        await _loadSelectedCategory(
          categoryId: categoryId,
          showLoading: false,
        );
      },
      failure: (message) {
        emit(HomeFailureState(message));
      },
    );
  }

  Future<void> getProducts(int? categoryId) async {
    _requestVersion++;
    this.categoryId = categoryId;
    _offset = 0;
    _hasMore = false;
    _isLoadingMore = false;
    _products.clear();
    emit(CategorySuccess(_categories));
    await _loadSelectedCategory(categoryId: categoryId, showLoading: true);
  }

  Future<void> _loadSelectedCategory({
    required int? categoryId,
    required bool showLoading,
  }) async {
    final requestVersion = _requestVersion;
    if (showLoading) emit(HomeProductsLoadingState());
    if (categoryId == null) {
      emit(HomeProductsFailureState('Category ID is unavailable.'));
      return;
    }

    final result = await homeProductsUseCase(
      categoryId,
      limit: pageSize,
      offset: 0,
    );

    if (requestVersion != _requestVersion || isClosed) return;
    result.when(
      success: (products) {
        _products
          ..clear()
          ..addAll(products);
        _offset = products.length;
        _hasMore = products.length == pageSize;
        emit(HomeProductsSuccessState(List.unmodifiable(_products)));
      },
      failure: (message) {
        emit(HomeProductsFailureState(message));
      },
    );
  }

  Future<void> loadProductsMore(int? categoryId) async {
    if (_isLoadingMore || !_hasMore || isClosed || categoryId == null) return;
    if (categoryId != this.categoryId) return;

    _isLoadingMore = true;
    final requestVersion = _requestVersion;
    final requestCategoryId = categoryId;
    emit(
      HomeProductsSuccessState(
        List.unmodifiable(_products),
        isLoadingMore: true,
      ),
    );

    try {
      final result = await homeProductsUseCase(
        requestCategoryId,
        limit: pageSize,
        offset: _offset,
      );

      if (requestVersion != _requestVersion || isClosed) return;
      result.when(
        success: (products) {
          _products.addAll(products);
          _offset += products.length;
          _hasMore = products.length == pageSize;
          emit(
            HomeProductsSuccessState(
              List.unmodifiable(_products),
            ),
          );
        },
        failure: (message) {
          emit(
            HomeProductsSuccessState(
              List.unmodifiable(_products),
              loadMoreError: message,
            ),
          );
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}
