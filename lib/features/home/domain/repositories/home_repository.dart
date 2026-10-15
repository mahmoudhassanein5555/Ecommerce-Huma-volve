import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_products_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeCategoriesEntity>>> getCategories();
  Future<Either<Failure, List<HomeProductsEntity>>> getProducts(
    int? categoryId, {
    required int limit,
    required int offset,
  });
}
