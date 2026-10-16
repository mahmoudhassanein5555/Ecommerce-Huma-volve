import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecase/categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecase/products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final CategoriesUseCase categoriesUseCase;
  final ProductsUseCase productsUseCase;
  int limit = 10;
  int offset = 0;
  bool isLoadingMore = false;
  bool hasMoreProducts = false;
  final List<ProductsEntity> _products = [];
  num? categoryId;

  HomeCubit(this.categoriesUseCase, this.productsUseCase)
    : super(HomeInitialState());

  void loadCategories() async {
    emit(CategoriesLoadingState());
    final categories = await categoriesUseCase.call();
    categories.fold(
      ifLeft: (Failure value) {
        emit(CategoriesErrorState(errorMessage: value.message));
      },
      ifRight: (List<CategoriesEntity> value) {
        categoryId = value.isNotEmpty ? value.first.id : null;
        emit(CategoriesSuccessState(categories: value));
        return categories;
      },
    );
    await loadProducts(categoryId);
  }

  Future<void> loadProducts(num? categoryId) async {
    this.categoryId = categoryId;

    offset = 0;
    isLoadingMore = false;
    hasMoreProducts = true;
    _products.clear();

    emit(ProductsLoadingState());

    final result = await productsUseCase.call(
      categoryId,
      limit: limit,
      offset: offset,
    );

    result.fold(
      ifLeft: (Failure failure) {
        hasMoreProducts = false;
        emit(ProductsErrorState(errorMessage: failure.message));
      },
      ifRight: (List<ProductsEntity> products) {
        _products.addAll(products);
        offset = _products.length;
        hasMoreProducts = products.length == limit;

        emit(ProductsSuccessState(products: _products));
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMoreProducts) return;

    isLoadingMore = true;
    emit(ProductsLoadingMoreState());

    final result = await productsUseCase.call(
      categoryId,
      limit: limit,
      offset: offset,
    );

    result.fold(
      ifLeft: (Failure failure) {
        emit(ProductsLoadingMoreErrorState(errorMessage: failure.message));
      },
      ifRight: (List<ProductsEntity> products) {
        _products.addAll(products);
        offset = _products.length;
        hasMoreProducts = products.length == limit;

        emit(ProductsSuccessState(products: _products));
      },
    );
    isLoadingMore = false;
  }
}
