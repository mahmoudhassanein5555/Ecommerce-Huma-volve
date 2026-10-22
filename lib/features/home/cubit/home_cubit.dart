import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/home_services.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeServices homeServices;
  HomeCubit(this.homeServices) : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoriesLoading());
    try {
      final categories = await homeServices.getCategories();
      emit(CategoriesSuccess(categories));
      if (categories.isNotEmpty) {
        fetchProducts(categories[0].id);
      }
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void fetchProducts(num? categoryId) async {
    emit(ProductsLoading());
    try {
      final products = await homeServices.getProducts(categoryId);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
