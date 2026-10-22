import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/cubit/home_stats.dart';
import 'package:ecommerce_app_huma_volve/features/home/home_services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_services/models/category_model.dart';

class HomeCubit extends Cubit<HomeStats> {
  final HomeService homeService;

  HomeCubit(this.homeService) : super(HomeInitial());
  int _productsRequestId = 0;
  List<CategoryModel> categories = [];

  void loadingData() async {
    emit(CategoriesLoading());
    try {
      final categories = await homeService.getCategories();
      emit(CategoriesSuccess(categories));
      final products = await homeService.getProducts(categories[0].id);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProducts({required int categoryId}) async {
    final requestId = ++_productsRequestId;
    emit(ProductsLoading());
    try {
      final products = await homeService.getProducts(categoryId);
      if (isClosed || requestId != _productsRequestId) return;
      emit(ProductsSuccess(products));
    } on DioException catch (e) {
      if (isClosed || requestId != _productsRequestId) return;
      emit(ProductsError(e.toString()));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
