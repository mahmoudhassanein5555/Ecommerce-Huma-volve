
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/category_entity.dart';
import '../domain/entities/product_entity.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    try {
      final List<CategoryEntity> categories =
          await getCategoriesUseCase.call();

      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProducts(int categoryId) async {
    emit(ProductsLoading());

    try {
      final List<ProductEntity> products =
          await getProductsUseCase.call(categoryId);

      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
