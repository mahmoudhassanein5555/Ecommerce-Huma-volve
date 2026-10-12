import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/home_services.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeServices _homeServices;

  List<CategoryModel> _categories = [];

  HomeCubit(this._homeServices) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    try {
      _categories = await _homeServices.getCategories();

      if (_categories.isEmpty) {
        emit(
          HomeSuccess(
            categories: _categories,
            products: [],
          ),
        );
        return;
      }

      await fetchProductsByCategory(_categories.first.id);
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    try {
      final products = await _homeServices.getProducts(
        categoryId: categoryId,
      );

      emit(
        HomeSuccess(
          categories: _categories,
          products: products,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}