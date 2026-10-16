import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/product_entity.dart';
import '../domain/usecases/get_products_use_case.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase getProductsUseCase;

  static const int pageSize = 10;

  int _offset = 0;
  bool _isFetching = false;
  bool _hasMore = true;

  final List<ProductEntity> _products = [];

  HomeCubit(this.getProductsUseCase) : super(HomeInitial());

  Future<void> getProducts() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;

    if (_offset == 0) {
      emit(HomeLoading());
    } else {
      emit(
        HomeSuccess(
          List<ProductEntity>.from(_products),
          isLoadingMore: true,
          hasMore: _hasMore,
        ),
      );
    }

    try {
      final newProducts = await getProductsUseCase(
        offset: _offset,
        limit: pageSize,
      );

      _products.addAll(newProducts);
      _offset += newProducts.length;

      _hasMore = newProducts.length == pageSize;

      emit(
        HomeSuccess(
          List<ProductEntity>.from(_products),
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      if (_products.isEmpty) {
        emit(HomeError(e.toString()));
      } else {
        emit(
          HomeSuccess(
            List<ProductEntity>.from(_products),
            hasMore: _hasMore,
          ),
        );
      }
    } finally {
      _isFetching = false;
    }
  }
}