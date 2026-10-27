import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/constants/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories();

  Future<Either<Failure, List<HomeProductEntity>>> getproducts(
    int? categoryid,
  );
}