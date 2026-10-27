import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_product_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presntation/view_model/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductUseCase getProductUseCase;

  HomeCubit({
    required this.getProductUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    // 1. Get Categories
    final categoriesResult = await getCategoriesUseCase.invoke();

    final categoryId = categoriesResult.fold<int?>(
      (failure) {
        emit(CategoriesError(failure.failureMessage));
        return null;
      },
      (categories) {
        if (categories.isEmpty) {
          emit(CategoriesError('No categories found'));
          return null;
        }

        emit(CategoriesSuccess(categories));

        // Get the real ID from the first category
        return categories.first.id;
      },
    );

    // Stop if categories failed or the list is empty
    if (categoryId == null) return;

    // 2. Get Products
    emit(ProductLoading());

    final productsResult =
        await getProductUseCase.invoke(categoryId);

    productsResult.fold(
      (failure) {
        emit(ProductError(failure.failureMessage));
      },
      (productsList) {
        emit(ProductSuccess(productsList));
      },
    );
  }

  Future<void> getProductsByCategoryId(int id) async {
    emit(ProductLoading());

    final productsResult = await getProductUseCase.invoke(id);

    productsResult.fold(
      (failure) {
        emit(ProductError(failure.failureMessage));
      },
      (productsList) {
        emit(ProductSuccess(productsList));
      },
    );
  }
}