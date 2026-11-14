import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';

import '../../../../core/failure/failure.dart';
import '../entities/product_entity.dart';

class GetProductUsecase {
  final HomeRepository _repository;
  GetProductUsecase({required this._repository});

  Future<Either<Failure, List<ProductEntity>>> invoke(
    int categoryId, {
    required int limit,
    required int offset,
  }) {
    return _repository.getProducts(categoryId, limit: limit, offset: offset);
  }
}
