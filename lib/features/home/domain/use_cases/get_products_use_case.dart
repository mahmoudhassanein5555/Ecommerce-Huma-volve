import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';

import '../entities/home_product_entity.dart';

class GetProductsUseCase {
  final HomeRepository homeRepository;

  GetProductsUseCase(this.homeRepository);

  Future<Either<Failure, List<HomeProductEntity>>> invoke(int? categoryId) =>
      homeRepository.getProducts(categoryId);
}
