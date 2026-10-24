import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/persentation/view_model/home_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStats> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());

  int _categorytId = 0;

  void loadingData() async {
    emit(CategoriesLoading());

    final categories = await getCategoriesUseCase.invoke();
    categories.fold(
      (failure) {
        emit(CategoriesError(failure.failureMessage));
      },
      (categories) {
        _categorytId = categories[_categorytId].id;
        emit(CategoriesSuccess(categories));
        getProducts(categorytId: _categorytId);
      },
    );
  }

  void getProducts({required categorytId}) async {
    final products = await getProductsUseCase.invoke(categorytId);
    products.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        emit(ProductsSuccess(products));
      },
    );
  }

  void changeSelectedCategory({required int categoryId}) async {
    _categorytId = categoryId;
    getProducts(categorytId: categoryId);
  }
}
