import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_category_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_product_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/failure.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';

part "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final GetCategoryUsecase getCategoryUsecase;
  final GetProductUsecase getProductUsecase;

  HomeCubit({required this.getCategoryUsecase, required this.getProductUsecase})
    : super(HomeInitial());

  static const _limit = 10;

  List<CategoryEntity> _category = [];
  List<ProductEntity> _products = [];
  int _offset = 0;
  bool _hasMore = true;
  bool _isFetching = false;
  int _selectedIndex = 0;
  int _latestRequestId = 0;

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    final categoriesResult = await getCategoryUsecase.invoke();

    if (isClosed) return;

    categoriesResult.fold((failure) => emit(CategoryFailure(failure)), (
      categoriesResult,
    ) {
      _category = categoriesResult;
      emit(CategorySuccess(categories: _category, selectedIndex: 0));
      if (_category.isNotEmpty) {
        loadProductsByCID(0);
      }
    });
  }

  Future<void> loadProductsByCID(int index) async {
    if (index < 0 || index >= _category.length) return; // 1) bounds check

    _products = [];
    _offset = 0;
    _hasMore = true;
    _isFetching = true;
    _selectedIndex = index;
    final requestId = ++_latestRequestId;

    emit(CategorySuccess(categories: _category, selectedIndex: index));
    emit(ProductLoading());

    final productsResult = await getProductUsecase.invoke(
      _category[index].id,
      limit: _limit,
      offset: _offset,
    );

    if (isClosed || requestId != _latestRequestId) return;
    _isFetching = false; // 2) release the flag, after the stale check

    productsResult.fold((failure) => emit(ProductFailure(failure)), (data) {
      _products = data;
      _offset += data.length; // 3) move by what arrived, not a fixed 10
      _hasMore = data.length == _limit;
      emit(ProductSuccess(products: _products));
    });
  }

  Future<void> loadMoreProducts() async {
    if (_isFetching || !_hasMore || _category.isEmpty) return;

    final requestId = _latestRequestId;
    _isFetching = true;
    emit(
      ProductSuccess(products: _products, isLoadingMore: true),
    ); // spinner on

    final result = await getProductUsecase.invoke(
      _category[_selectedIndex].id,
      limit: _limit,
      offset: _offset,
    );

    if (isClosed || requestId != _latestRequestId) return;
    _isFetching = false;

    result.fold(
      (failure) {
        emit(
          LoadMoreProductsError(
            errorMessage: "Couldn't load more products",
            products: _products,
          ),
        );
      },
      (data) {
        _products = [..._products, ...data];
        _offset += data.length;
        _hasMore = data.length == _limit;
        emit(ProductSuccess(products: _products)); // spinner off
      },
    );
  }
}
