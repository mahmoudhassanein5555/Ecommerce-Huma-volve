import 'package:ecommerce_app_huma_volve/features/home/services/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/home_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService _homeService;
  HomeCubit(this._homeService) : super(HomeInitial());

  List<CategoryModel> category = [];
  Future<void> loadHomeData() async {
    emit(CategoryLoading());

    try {
      category = await _homeService.getCategories();

      emit(CategorySuccess(category, selectedIndex: 0));
      if (category.isNotEmpty) {
        await selectCategory(0);
      }
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }

  Future<void> selectCategory(int index) async {
    emit(CategorySuccess(category, selectedIndex: index));
    emit(ProductLoading());
    try {
      final product = await _homeService.getProducts(category[index].id);
      emit(ProductSuccess(product));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }
}
