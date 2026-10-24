import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_product_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_categories_use_case.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  void loadHomeData() async {
    int? categoryId = 0;
    emit(CategoriesLoading());
    try {
      final categories = await getCategoriesUseCase.invoke();
      categoryId = categories[0].id as int?;
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
      final products = await getProductsUseCase.invoke(categoryId);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void getProductsByCategoryId(int id) async {
    emit(ProductsLoading());
    try {
      final products = await getProductsUseCase.invoke(id);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
