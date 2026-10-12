import 'package:ecommerce_app_huma_volve/features/home/cubit/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/home_service.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeService homeService;
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  HomeCubit(this.homeService) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());
    try {
      final fetchedCategories = await homeService.getCategories();
      categories = [
        CategoryModel(id: 0, name: "All"),
        ...fetchedCategories,
      ];
      emit(CategoriesSuccess(categories));
      await getProducts(null);
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProducts(int? categoryId) async {
    emit(ProductsLoading());
    try {
      products = await homeService.getProducts(categoryId);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
