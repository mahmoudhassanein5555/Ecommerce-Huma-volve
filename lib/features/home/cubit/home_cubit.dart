

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/product_entity.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  static const int _pageSize = 10;

  int _offset = 0;
  int? _currentCategoryId;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<ProductEntity> _products = [];

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    try {
      final categories = await getCategoriesUseCase.call();
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProducts(int categoryId) async {
    _currentCategoryId = categoryId;
    _offset = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _products = [];

    emit(ProductsLoading());

    try {
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
          List.unmodifiable(_products),
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore ||
        !_hasMore ||
        _currentCategoryId == null) {
      return;
    }

    if (state is! ProductsSuccess) return;

    _isLoadingMore = true;

    emit(
      ProductsSuccess(
        List.unmodifiable(_products),
        isLoadingMore: true,
        hasMore: _hasMore,
      ),
    );

    try {
      final products = await getProductsUseCase.call(
        _currentCategoryId!,
        offset: _offset,
        limit: _pageSize,
      );

      final existingIds =
          _products.map((product) => product.id).toSet();

      final newProducts = products
          .where(
            (product) => !existingIds.contains(product.id),
          )
          .toList();

      _products = [..._products, ...newProducts];

      _offset += products.length;
      _hasMore = products.length == _pageSize;
    } catch (e) {
      emit(ProductsError(e.toString()));
      return;
    } finally {
      _isLoadingMore = false;
    }

    emit(
      ProductsSuccess(
        List.unmodifiable(_products),
        hasMore: _hasMore,
      ),
    );
  }
}
