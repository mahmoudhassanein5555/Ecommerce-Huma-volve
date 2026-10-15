import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/product_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProducts _getProducts;

  ProductCubit(this._getProducts) : super(ProductsInitial());

  int? _categoryId;
  int _nextOffset = 0;
  int _requestGeneration = 0;

  Future<void> loadProducts({int? categoryId}) async {
    _categoryId = categoryId;
    _nextOffset = categoryId == null
        ? ApiConsts.allProductsInitialOffset
        : 0;
    final generation = ++_requestGeneration;
    emit(ProductsLoading());

    final result = await _getProducts(
      categoryId: categoryId,
      offset: _nextOffset,
    );
    if (generation != _requestGeneration || isClosed) return;

    result.fold(
      (failure) => emit(ProductsError(failure.msg)),
      (products) {
        _nextOffset += ApiConsts.productsLimit;
        emit(
          ProductsLoaded(
            products: products,
            hasMore: products.length == ApiConsts.productsLimit,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ProductsLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    final generation = _requestGeneration;
    emit(
      ProductsLoaded(
        products: currentState.products,
        hasMore: currentState.hasMore,
        isLoadingMore: true,
      ),
    );

    final result = await _getProducts(
      categoryId: _categoryId,
      offset: _nextOffset,
    );
    if (generation != _requestGeneration || isClosed) return;

    result.fold(
      (failure) => emit(
        ProductsLoaded(
          products: currentState.products,
          hasMore: currentState.hasMore,
          loadMoreError: failure.msg,
        ),
      ),
      (products) {
        final allProducts = <Product>[...currentState.products, ...products];
        _nextOffset += ApiConsts.productsLimit;
        emit(
          ProductsLoaded(
            products: allProducts,
            hasMore: products.length == ApiConsts.productsLimit,
          ),
        );
      },
    );
  }
}
