import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/use_case/get_catergory_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/use_case/get_product_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  GetCatergoryUseCase getCategoriesUseCase;
  GetProductUseCase getProductsUseCase;
  final List<HomeProductEntity> products = [];
  late int offSet = 0;
  int idCategory = 0;
  bool isLoadingMoreProducts = false;
  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitialState());

  bool hasMore = true;

  Future<void> LoadHome() async {
    emit(HomeLoadingState());

    final categories = await getCategoriesUseCase.execute();
    categories.fold(
      (failure) => emit(CategoriesErrorState(failure.FailureMessage)),
      (categories) {
        emit(CategoriesSuccessState(categories));
        LoadProducts(-1);
      },
    );
  }

  Future<void> LoadProducts(int categoryId) async {
    offSet = 0;
    products.clear();
    idCategory = categoryId;
    emit(ProductsLoadedState());

    final data = await getProductsUseCase.execute(idCategory, offSet);

    data.fold((failure) => emit(ProductsErrorState(failure.FailureMessage)), (
      newProducts,
    ) {
      offSet = products.length;
      products.addAll(newProducts);
      emit(ProductsSuccessState(products));
    });
  }

  Future<void> LaodMoreProduct() async {
    if (isLoadingMoreProducts || !hasMore) return;
    emit(MoreProductsLoadedState());

    isLoadingMoreProducts = true;
    final data = await getProductsUseCase.execute(idCategory, offSet);
    data.fold(
      (failure) => emit(MoreProductsErrorState(failure.FailureMessage)),
      (newProducts) {
        if (newProducts.length < 10) hasMore = false;
        offSet = products.length;
        products.addAll(newProducts);
        emit(ProductsSuccessState(products));
        isLoadingMoreProducts = false;
      },
    );
  }
}
