import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repos/home_repo.dart';

class HomeProductsUseCase {
  final HomeRepo homeRepo;

  HomeProductsUseCase(this.homeRepo);

  Future<ApiResult<List<ProductEntity>>> call(
    int? categoryId, {
    required int limit,
    required int offset,
  }) async {
    return homeRepo.getProducts(categoryId, limit: limit, offset: offset);
  }
}
