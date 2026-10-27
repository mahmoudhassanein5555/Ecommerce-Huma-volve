import 'package:ecommerce_app_huma_volve/core/network/api_call.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/core/utils/mapper_to_domain.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepoImpl(this.homeRemoteDataSource);

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() {
    return apiCall(() async {
      final categories = await homeRemoteDataSource.getCategories();
      return categories.map((category) => category.toDomain()).toList();
    });
  }

  @override
  Future<ApiResult<List<ProductEntity>>> getProducts(
    int? categoryId, {
    required int limit,
    required int offset,
  }) {
    return apiCall(() async {
      final products = await homeRemoteDataSource.getProducts(
        categoryId: categoryId,
        limit: limit,
        offset: offset,
      );
      return products.map((product) => product.toDomain()).toList();
    });
  }
}
