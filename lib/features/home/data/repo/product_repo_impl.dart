import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/app_exptions.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/remote/product_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/product_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductRepo)
class ProductRepoImpl implements ProductRepo {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int? categoryId,
    required int offset,
  }) async {
    try {
      final products = await _remoteDataSource.getProducts(
        categoryId: categoryId,
        offset: offset,
      );
      return Right(products);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    }
  }
}
