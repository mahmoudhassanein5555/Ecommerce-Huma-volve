import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failures.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';

class GetProductUseCase {
  final HomeRepository homeRepository;

  GetProductUseCase(this.homeRepository);

  Future<Either<Failures, List<HomeProductEntity>>> invoke(int? categoryId) {
    return homeRepository.getProductByCategoryId(categoryId);
  }
}
