import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories();
  Future<Either<Failure, List<HomeProductEntity>>> getProducts(
    int categoryId,
    int offSet,
  );
}
