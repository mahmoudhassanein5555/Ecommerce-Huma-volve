import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/product_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetProducts {
  final ProductRepo _productRepo;

  GetProducts(this._productRepo);

  Future<Either<Failure, List<Product>>> call({
    int? categoryId,
    required int offset,
  }) {
    return _productRepo.getProducts(categoryId: categoryId, offset: offset);
  }
}
