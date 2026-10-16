
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/category_entity.dart';
import '../domain/entities/product_entity.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
  }) : super(HomeInitial());

  static const int _pageSize = 10;

  int _offset = 0;
  int? _currentCategoryId;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<ProductEntity> _products = [];
  List<CategoryEntity> _categories = [];
  List<CategoryEntity> get categories => _categories;

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    try {
      _categories = await getCategoriesUseCase.call();

      _currentCategoryId = _categories.isNotEmpty
          ? _categories.first.id
          : null;

      if (_currentCategoryId == null) {
        _products = [];
        _offset = 0;
        _hasMore = false;
        emit(CategoriesSuccess(_categories));
        return;
      }

      await _loadProductsForCategory(_currentCategoryId!);
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProducts(int categoryId) async {
    _currentCategoryId = categoryId;
    await _loadProductsForCategory(categoryId);
  }

  Future<void> _loadProductsForCategory(int categoryId) async {
    emit(ProductsLoading());

    try {
      _offset = 0;
      _hasMore = true;
      _products = [];

      final products = await getProductsUseCase.call(
        categoryId,
        offset: _offset,
        limit: _pageSize,
      );

      _products = products;
      _offset = products.length;
      _hasMore = products.length == _pageSize;

      emit(
        ProductsSuccess(
          List<ProductEntity>.from(_products),
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore || _currentCategoryId == null) {
      return;
    }

    final currentState = state;
    if (currentState is! ProductsSuccess) return;

    _isLoadingMore = true;

    emit(
      ProductsSuccess(
        List<ProductEntity>.from(_products),
        isLoadingMore: true,
        hasMore: _hasMore,
      ),
    );

    try {
      final newProducts = await getProductsUseCase.call(
        _currentCategoryId!,
        offset: _offset,
        limit: _pageSize,
      );

      _products.addAll(newProducts);
      _offset += newProducts.length;
      _hasMore = newProducts.length == _pageSize;

      emit(
        ProductsSuccess(
          List<ProductEntity>.from(_products),
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(ProductsError(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<ProductEntity> getProductById(int id) {
    return getProductByIdUseCase.call(id);
  }
}
