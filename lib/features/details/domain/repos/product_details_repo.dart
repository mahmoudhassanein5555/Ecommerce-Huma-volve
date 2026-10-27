import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';

abstract class ProductDetailsRepo {
  Future<ApiResult<ProductDetailsEntity>> getProductById(int productId);
}
