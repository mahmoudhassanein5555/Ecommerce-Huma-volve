
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

  HomeCubit(this.categoriesUseCase, this.productsUseCase)
    : super(HomeInitialState());

  void loadCategories() async {
    emit(CategoriesLoadingState());
    try {
      final categories = await categoriesUseCase.call();
      categories.fold(
        ifLeft: (Failure value) {
          emit(CategoriesErrorState(errorMessage: value.message));
        },
        ifRight: (List<CategoriesEntity> value) {
          emit(CategoriesSuccessState(categories: value));
        },
      );
    } catch (e) {
      emit(CategoriesErrorState(errorMessage: e.toString()));
    }
  }

  void loadProducts(num? categoryId) async {
    emit(ProductsLoadingState());
    try {
      final products = await productsUseCase.call(categoryId);
      products.fold(
        ifLeft: (Failure value) {
          emit(ProductsErrorState(errorMessage: value.message));
        },
        ifRight: (List<ProductsEntity> value) {
          emit(ProductsSuccessState(products: value));
        },
      );
    } catch (e) {
      emit(ProductsErrorState(errorMessage: e.toString()));
    }
  }
}