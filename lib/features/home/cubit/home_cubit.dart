import 'package:ecommerce_app_huma_volve/features/home/cubit/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeService homeService;
  HomeCubit(this.homeService) : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoriesLodaing());
    try {
      final categories = await homeService.getCategories();
      emit(CategoriesSuccess(categories));
      if (categories.isNotEmpty) {
        await loadProductsByCategory(categories[0].id);
      }
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> loadProductsByCategory(int? categoryId) async {
    emit(ProductsLoading());
    try {
      final products = await homeService.getProducts(categoryId);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}