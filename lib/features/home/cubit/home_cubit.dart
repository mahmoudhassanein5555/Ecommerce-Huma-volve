import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';

import 'package:ecommerce_app_huma_volve/features/home/model/home_service/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeService homeService;

  HomeCubit({required this.homeService}) : super(HomeInitialState());

  void loadCategories() async {
    emit(CategoriesLoadingState());
    try {
      final categories = await homeService.getCategories();
      emit(CategoriesSuccessState(categories: categories));
    } catch (e) {
      emit(CategoriesErrorState(errorMessage: e.toString()));
    }
  }

  void loadProducts(num? categoryId) async {
    emit(ProductsLoadingState());
    try {
      final products = await homeService.getProducts(categoryId);
      emit(ProductsSuccessState(products: products));
    } catch (e) {
      emit(ProductsErrorState(errorMessage: e.toString()));
    }
  }
}
