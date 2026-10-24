import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';

import '../entities/product_entity.dart';
import '../repositories/home_repo.dart';

class GetProductsUseCase {
  final HomeRepo homeRepository;
  GetProductsUseCase(this.homeRepository);

  Future<Either<Failure, List<ProductEntity>>> invoke(int? categoryId) =>
      homeRepository.getProducts(categoryId);
}
