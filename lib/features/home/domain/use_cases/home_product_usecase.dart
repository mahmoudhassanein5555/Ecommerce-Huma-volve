import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';

class HomeProductUsecase {
  final HomeRepository homeRepository;

  HomeProductUsecase(this.homeRepository);

  Future<Either<Failure, List<HomeProductsEntity>>> call(
    int? categoryId, {
    required int limit,
    required int offset,
  }) async => await homeRepository.getProducts(
    categoryId,
    limit: limit,
    offset: offset,
  );
}
