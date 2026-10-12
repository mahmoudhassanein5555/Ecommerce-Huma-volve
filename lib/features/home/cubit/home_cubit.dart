import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeServices homeServices;

  HomeCubit({required this.homeServices}) : super(HomeInitialState());

  Future<void> LoadHome() async {
    emit(HomeLoadingState());
    bool isCategoriesLoaded = false;
    try {
      final categories = await homeServices.getCategories();
      isCategoriesLoaded = true;
      emit(categoriesSuccessState(categories));

      LoadProducts(-1);
    } catch (e) {
      if (!isCategoriesLoaded) {
        emit(categoriesErrorState(e.toString()));
      } else {
        emit(productsErrorState(e.toString()));
      }
    }
  }

  Future<void> LoadProducts(int categoryId) async {
    emit(productsLoadedState());
    try {
      final products = await homeServices.getProducts(categoryId);
      emit(productsSuccessState(products));
    } catch (e) {
      emit(productsErrorState(e.toString()));
    }
  }
}
