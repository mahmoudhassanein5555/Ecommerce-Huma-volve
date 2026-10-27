import 'package:ecommerce_app_huma_volve/core/network/api_call.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/datasources/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repos/product_details_repo.dart';

class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepoImpl(this.remoteDataSource);

  @override
  Future<ApiResult<ProductDetailsEntity>> getProductById(int productId) {
    return apiCall(() async {
      final product = await remoteDataSource.getProductById(productId);
      return product.toDomain();
    });
  }
}
