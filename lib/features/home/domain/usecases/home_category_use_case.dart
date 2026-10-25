import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repos/home_repo.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/home_products_use_case.dart';

class HomeCategoryUseCase {
  final HomeRepo homeRpo;
  HomeCategoryUseCase(this.homeRpo, HomeProductsUseCase homeProductsUseCase);
 Future<ApiResult<List<CategoryEntity>>> call() async{
   return await homeRpo.getCategories();
  }

}