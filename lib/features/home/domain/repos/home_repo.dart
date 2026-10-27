import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';

abstract class HomeRepo {
  Future<ApiResult<List<CategoryEntity>>> getCategories();
  Future<ApiResult<List<ProductEntity>>> getProducts(
    int? categoryId, {
    required int limit,
    required int offset,
  });
}
