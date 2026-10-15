import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/home_category_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/home_product_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeCategoryUsecase homeCategoryUsecase;
  final HomeProductUsecase homeProductUsecase;

  //* Pagination constants and variables
  final int limit = 10;
  int offset = 0;
  bool isLoadingMore =
      false; //* Prevents sending duplicate requests simultaneously
  bool hasMore =
      true; //*  Checks if there are more products available on the server
  //* Keep track of current products to accumulate them
  List<HomeProductsEntity> allProducts = [];
  int? currentCategoryId; //* Keep track of the current category

  HomeCubit(this.homeCategoryUsecase, this.homeProductUsecase)
    : super(HomeInitial());

  void getCategories() async {
    emit(CategoriesLoading());
    final categories = await homeCategoryUsecase.call();
    categories.fold(
      (failure) => emit(CategoriesError(failure.failureMessage)),
      (success) => emit(CategoriesSuccess(success)),
    );
  }

  void getProducts(int? categoryId) async {
    currentCategoryId = categoryId;
    offset = 0; // Reset offset to the beginning
    hasMore = true; // Reset pagination availability flag
    allProducts.clear(); // Clear old products list
    emit(ProductsLoading());

    final products = await homeProductUsecase.call(
      categoryId,
      limit: limit,
      offset: offset,
    );
    products.fold((failure) => emit(ProductsError(failure.failureMessage)), (
      success,
    ) {
      allProducts = success; // Store the fetched products
      // If the returned products are less than the limit, no more pages exist
      if (success.length < limit) {
        hasMore = false;
      }
      emit(ProductsSuccess(List.from(allProducts)));
    });
  }

  // 2. Fetch more products when scrolling to the bottom (Pagination)
  void loadMoreProducts() async {
    // Return early if already loading or if no more data is available
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    emit(ProductLoadingMore());

    offset +=
        limit; // Increment offset by the limit (e.g., skip previous items)

    final result = await homeProductUsecase.call(
      currentCategoryId,
      limit: limit,
      offset: offset,
    );

    result.fold(
      (failure) {
        isLoadingMore = false;
        offset -= limit; // Revert offset if the request fails
      },
      (newProducts) {
        isLoadingMore = false;
        if (newProducts.isEmpty || newProducts.length < limit) {
          hasMore = false; // No more products left to fetch
        }
        allProducts.addAll(
          newProducts,
        ); // Append new products to the existing list
        emit(
          ProductsSuccess(List.from(allProducts)),
        ); // Update UI with the full list
      },
    );
  }
}
