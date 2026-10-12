
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/home_service.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;

  HomeCubit({HomeService? homeService})
      : homeService = homeService ?? HomeService(),
        super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    try {
      final categories = await homeService.getCategories();
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProducts(int categoryId) async {
    emit(ProductsLoading());

    try {
      final products = await homeService.getProducts(categoryId);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
