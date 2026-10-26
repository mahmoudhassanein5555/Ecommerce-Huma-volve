import 'package:ecommerce_app_huma_volve/features/home/cubit/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeService homeService;

  HomeCubit(this.homeService) : super(Homeinitile());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    try {
      final categories = await homeService.getCategares();
      emit(CategoriesSuccess(categories));

      if (categories.isEmpty) {
        emit(productsuccess([]));
        return;
      }

      emit(productLoading());

      final products =
          await homeService.getproducts(categories.first.id);

      emit(productsuccess(products));
    } catch (e) {
      emit(categoriesError(e.toString()));
    }
  }
  Future<void> loadProducts(int? categoryId) async {
  emit(productLoading());

  try {
    final products = await homeService.getproducts(categoryId);
    emit(productsuccess(products));
  } catch (e) {
    emit(productError(e.toString()));
  }
}
}