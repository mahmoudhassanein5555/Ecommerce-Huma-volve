import 'package:bloc/bloc.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/products_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_category_use_Case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_product_use_Case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoryUseCase getCategoryUseCase;
  final GetProductUseCase getProductUseCase;
  List<CategoryResponseModel> categories = [];
  List<ProductsResponseModel> products = [];

  HomeCubit(this.getCategoryUseCase, this.getProductUseCase)
    : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoryLoading());
    final categories = await getCategoryUseCase.invoke();
    categories.fold(
      (failures) {
        emit(CategoryFailure(failures.errorMessage));
      },
      (success) {
        emit(CategorySuccess(success));
        if (success.isNotEmpty) {
          getProductsByCategory(success[0].id);
        }
      },
    );
  }

  void getProductsByCategory(int? categoryId) async {
    emit(ProductLoading());
    final products = await getProductUseCase.invoke(categoryId);
    products.fold(
      (failures) {
        emit(ProductFailure(failures.errorMessage));
      },
      (success) {
        emit(ProductSuccess(success));
      },
    );
  }
}
