import 'package:bloc/bloc.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_all_products.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_products.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'all_products_state.dart';

class AllProductsCubit extends Cubit<AllProductsState> {
  AllProductsCubit(
    this.getAllProducts,
    this.getCategoriesProducts,
  ) : super(AllProductsInitial());

  final GetAllProducts getAllProducts;
  final GetCategoriesProducts getCategoriesProducts;

  int page = 0;
  int categoryId = 0;
  bool isLoading = false;
  bool hasMoreData = true;
  List<Product> products = [];
  static const int limit = 10;

  Future<void> getAllProductsMethod() async {
    _resetPagination();
    emit(AllProductsLoading());
    final response = await getAllProducts(limit: limit, offset: page * limit);
    response.fold(
      (failure) {
        emit(AllProductsFail(errorMessage: failure.displayMessage));
      },
      (result) async {
        products = result;
        hasMoreData = result.length >= limit;
        emit(AllProductsSuccess(products: products, hasMoreData: hasMoreData));
      },
    );
  }

  Future<void> getCategoriesProductsMethod(int id) async {
    _resetPagination();
    categoryId = id;
    emit(AllProductsLoading());
    final response = await getCategoriesProducts(
      categoryId: categoryId,
      limit: limit,
      offset: page * limit,
    );
    response.fold(
      (failure) {
        emit(AllProductsFail(errorMessage: failure.displayMessage));
      },
      (result) async {
        products = result;
        hasMoreData = result.length >= limit;
        emit(AllProductsSuccess(products: products, hasMoreData: hasMoreData));
      },
    );
  }

  Future<void> getNextPage() async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    page++;

    final response = categoryId == 0
        ? await getAllProducts(limit: limit, offset: page * limit)
        : await getCategoriesProducts(
            categoryId: categoryId,
            limit: limit,
            offset: page * limit,
          );

    response.fold(
      (failure) {
        emit(AllProductsFail(errorMessage: failure.displayMessage));
      },
      (result) {
        final newProducts = result;

        if (newProducts.isEmpty) {
          hasMoreData = false;
        } else {
          products.addAll(newProducts);
          hasMoreData = newProducts.length >= limit;
        }

        emit(
          AllProductsSuccess(products: products, hasMoreData: hasMoreData),
        );
      },
    );

    isLoading = false;
  }

  void _resetPagination() {
    page = 0;
    categoryId = 0;
    isLoading = false;
    hasMoreData = true;
    products = [];
  }
}
