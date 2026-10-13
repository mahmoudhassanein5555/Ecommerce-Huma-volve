import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/home_category_entity.dart';
import '../domain/usecases/get_home_categories_usecase.dart';
import '../domain/usecases/get_home_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeCategoriesUseCase getCategoriesUseCase;
  final GetHomeProductsUseCase getProductsUseCase;

  List<HomeCategoryEntity> _categories = [];

  HomeCubit(homeServices, {
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    try {
      _categories = await getCategoriesUseCase();

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
      final products = await getProductsUseCase(
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