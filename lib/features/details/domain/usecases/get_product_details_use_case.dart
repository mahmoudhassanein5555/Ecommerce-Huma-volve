import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repos/product_details_repo.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepo productDetailsRepo;

  GetProductDetailsUseCase(this.productDetailsRepo);

  Future<ApiResult<ProductDetailsEntity>> call(int productId) {
    return productDetailsRepo.getProductById(productId);
  }
}
