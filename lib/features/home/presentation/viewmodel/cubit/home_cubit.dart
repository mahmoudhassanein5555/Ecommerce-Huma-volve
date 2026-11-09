import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/get_category_usecase.dart';
import '../../../domain/usecases/get_product_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoryUsecase _getCategoryUsecase;
  final GetProductUsecase _getProductUsecase;

  HomeCubit({
    required this._getCategoryUsecase,
    required this._getProductUsecase,
  }) : super(HomeInitial());

  List<CategoryEntity> category = [];

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    final result = await _getCategoryUsecase.invoke();
    if (isClosed) return;

    result.fold((failure) => emit(CategoryFailure(failure)), (data) {
      category = data;

      if (category.isNotEmpty) {
        loadProductByCID(0);
      } else {
        emit(CategorySuccess(category, selectedIndex: 0));
      }
    });
  }

  Future<void> loadProductByCID(int index) async {
    if (index < 0 || index >= category.length) return;

    emit(CategorySuccess(category, selectedIndex: index));

    emit(ProductLoading());

    final product = await _getProductUsecase.invoke(category[index].id);
    if (isClosed) return;

    product.fold(
      (failure) => emit(ProductFailure(failure)),
      (product) => emit(ProductSuccess(product)),
    );
  }
}
