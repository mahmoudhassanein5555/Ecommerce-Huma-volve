import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final int limit =10;
  int offset = 0;
  bool isLoadingMore =false; 
  bool hasMore =true;
  int? selectedCategory;
  int _productsRequestId = 0;
  final List<HomeProductEntity> _products = [];

  HomeCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoadingState());

    final categoriesResult = await getCategoriesUseCase.invoke();
    // List<HomeCategoryEntity> categories = [];
    int id = 0;
    categoriesResult.fold(
      (failure) {
        emit(CategoriesFailureState(failure.failureMessage));
      },
      (categoriesResult) {
        // final categories = categoriesResult;
        id = categoriesResult.first.id;
        emit(CategoriesSuccessState(categoriesResult));
      },
    );
    await getProductsByCategoryId(id);
  }

  Future<void> getProductsByCategoryId(int id) async {
    final requestId = ++_productsRequestId;
    selectedCategory = id;
    offset = 0;
    isLoadingMore = false;
    _products.clear();
    emit(ProductsLoadingState());
    hasMore = true;
    final products = await getProductsUseCase.invoke(id, offset: offset, limit: limit);
    if (requestId != _productsRequestId) return;

    products.fold(
      (failure) {
        emit(ProductsFailureState(failure.failureMessage));
      },
      (products) {
        _products.addAll(products);
        offset = products.length;
        if(products.length < limit) {
          hasMore = false;
        }
        emit(ProductsSuccessState(products));
      },
    );
  }

Future<void> loadMoreProducts() async {
  if (isLoadingMore || !hasMore || selectedCategory == null) return;
  isLoadingMore = true;
  final requestId = _productsRequestId;
  emit(ProductsLoadingMore());

  final result = await getProductsUseCase.invoke(
    selectedCategory,
    limit: limit,
    offset: offset,
  );

  if (requestId != _productsRequestId) return;
  isLoadingMore = false;

  result.fold(
    (failure) {
      emit(ProductsLoadingError(errorMessage: failure.failureMessage));
    },
    (newProducts) {
      _products.addAll(newProducts);
      offset += newProducts.length;
      if (newProducts.length < limit) {
        hasMore = false;
      }
      emit(ProductsSuccessState(List.from(_products)));
    },
  );
}
}
