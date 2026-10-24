import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_catagory_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_product_use_case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  List<CategoryEntity> categories = [];
  List<ProductEntity> products = [];

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());
    final result = await getCategoriesUseCase.invoke();
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (data) {
        categories = data;
        emit(CategorySuccess(categories: categories));
      },
    );
  }

  Future<void> getProducts({int? categoryId}) async {
    emit(ProductsLoading());
    final result = await getProductsUseCase.invoke(categoryId);
    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (data) {
        products = data;
        emit(ProductsSuccess(products: products));
      },
    );
  }
}
