import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_service.dart';
import 'package:meta/meta.dart';

import '../models/product_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  Future<void> loadHome() async {
    emit(HomeLoadingState());
    try {
      final category = await HomeService.getCategories();
      emit(CategorySuccess(category));
      if (category.isEmpty) {
        emit(HomeProductsSuccessState(const []));
        return;
      }
      final product = await HomeService.getCategoryById(id: category.first.id);
      emit(HomeProductsSuccessState(product));
    } catch (e) {
      emit(HomeFailureState(e.toString()));
    }
  }

  Future<void> getProducts(int? categoryId) async {
    emit(HomeProductsLoadingState());
    try {
      final products = await HomeService.getCategoryById(id: categoryId);
      emit(HomeProductsSuccessState(products));
    } catch (e) {
      emit(HomeProductsFailureState(e.toString()));
    }
  }
}
