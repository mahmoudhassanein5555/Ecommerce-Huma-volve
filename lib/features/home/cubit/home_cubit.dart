import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app_huma_volve/features/home/cubit/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/home_service.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeService homeService;
  List<CategoryModel> _categories = [];
  int? _selectedCategoryId;

  HomeCubit(this.homeService) : super(HomeInitial());

  List<CategoryModel> get categories => _categories;

  int? get selectedCategoryId => _selectedCategoryId;

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    try {
      _categories = await homeService.getCategories();
      emit(CategoriesSuccess(_categories));

      if (_categories.isEmpty) {
        emit(ProductsSuccess(const []));
        return;
      }

      final categoryId = _categories.first.id;
      if (categoryId == null) {
        emit(ProductsSuccess(const []));
        return;
      }

      await loadProducts(categoryId: categoryId);
    } catch (error) {
      emit(CategoriesError(error.toString()));
    }
  }

  Future<void> loadProducts({required int categoryId}) async {
    _selectedCategoryId = categoryId;
    emit(ProductsLoading());

    try {
      final products = await homeService.getProducts(categoryId: categoryId);
      emit(ProductsSuccess(products));
    } catch (error) {
      emit(ProductsError(error.toString()));
    }
  }
}
