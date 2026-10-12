import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/home_services.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeService homeService;
  HomeCubit(this.homeService) : super(HomeInitial());

  void loadHomeData() async {
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

  void getProductsByCategoryId(int id) async {
    emit(ProductsLoading());
    try {
      final products = await homeService.getProducts(id);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
