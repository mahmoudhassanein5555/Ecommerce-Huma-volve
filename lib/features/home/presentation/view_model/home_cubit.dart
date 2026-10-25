import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_product_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_product_entity.dart';
import '../../domain/use_cases/get_categories_use_case.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final List<HomeProductEntity> products = [];
  final int limit = 10;
  int offset = 0;
  int? selectedCategory;
  bool isLoadingMore = false;
  bool hasMore = true;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoriesLoading());
    try {
      final categories = await getCategoriesUseCase.invoke();
      emit(CategoriesSuccess(categories));

      if (categories.isNotEmpty) {
        fetchProducts(categories[0].id);
      }
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void fetchProducts(num? categoryId) async {
    offset = 0;
    products.clear();
    hasMore = true;
    selectedCategory = categoryId?.toInt();
    emit(ProductsLoading());
    try {
      final result = await getProductsUseCase.invoke(
        categoryId,
        limit: limit,
        offset: offset,
      );
      products.addAll(result);
      offset = products.length;
      if (result.length < limit) {
        hasMore = false;
      }
      emit(ProductsSuccess(List.from(products)));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void getProductsByCategoryId(int id) async {
    fetchProducts(id);
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    emit(ProductsLoadMore());

    try {
      final result = await getProductsUseCase.invoke(
        selectedCategory,
        limit: limit,
        offset: offset,
      );

      if (result.isNotEmpty) {
        products.addAll(result);
        offset += result.length;
        if (result.length < limit) {
          hasMore = false;
        }
        emit(ProductsSuccess(List.from(products)));
      } else {
        hasMore = false;
        emit(ProductsLoadMoreError("No more products to load"));
      }
    } catch (e) {
      emit(ProductsLoadMoreError(e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }
}
